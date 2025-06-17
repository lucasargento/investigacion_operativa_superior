import os
import json
import pymzn
from typing import Dict, Any, List, Optional
from text2pysolve import evaluate_example, ResultsManager, create_python_model_prompt, execute_generated_code, compare_results, clean_code
from datasets import load_dataset
from tqdm import tqdm
import traceback
from openai import OpenAI

class DatasetManager:
    def __init__(self, dataset_name: str = "TEXT2ZINC", output_dir: str = "output"):
        """
        Initialize the dataset manager.
        Args:
            dataset_name: Name of the dataset to load
            output_dir: Directory to save results
        """
        self.dataset_name = dataset_name
        self.output_dir = output_dir
        self.results_manager = ResultsManager(output_dir)
        self.dataset = None
        self.examples = []
    
    def load_dataset(self) -> None:
        """Load the dataset from Hugging Face."""
        print("Loading dataset from Hugging Face...")
        try:
            self.dataset = load_dataset("skadio/text2zinc")
            print("Dataset loaded successfully!")
            print(f"Available splits: {list(self.dataset.keys())}")
            print(f"Number of examples in train split: {len(self.dataset['train'])}")
        except Exception as e:
            print(f"Error loading dataset: {str(e)}")
            return
    
    def filter_verified_examples(self) -> None:
        """Filter examples to only include verified ones."""
        print("Filtering verified examples...")
        if not self.dataset:
            print("No dataset loaded!")
            return
            
        self.examples = [
            example for example in self.dataset['train']
            if example.get('is_verified', False)
        ]
        print(f"Found {len(self.examples)} verified examples")
    
    def analyze_differences(self, generated_output: Dict[str, Any], expected_output: Dict[str, Any], problem_description: str, generated_model: str) -> str:
        """
        Ask GPT to analyze the differences between generated and expected outputs.
        Args:
            generated_output: The output from the generated model
            expected_output: The expected output from the example
            problem_description: The problem description
            generated_model: The generated Python model code
        Returns:
            Analysis of the differences and suggestions for improvement
        """
        prompt = f"""Analyze the differences between the generated solution and the expected solution for this optimization problem.

            Problem Description:
            {problem_description}

            Generated Python Model:
            {generated_model}

            Generated Solution:
            {json.dumps(generated_output, indent=2)}

            Expected Solution:
            {json.dumps(expected_output, indent=2)}

            Please:
            1. Identify the key differences between the solutions
            2. Explain why these differences might be occurring
            3. Suggest specific improvements to the Python implementation to better match the expected output
            4. Point out any potential issues with the model formulation or constraints

            Focus on the mathematical and logical aspects of the differences, not just the numerical values.
        """

        client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
        response = client.chat.completions.create(
            model="gpt-4-turbo-preview",
            messages=[{"role": "user", "content": prompt}],
            temperature=0.1
        )
        return response.choices[0].message.content

    def improve_code(self, original_code: str, analysis: str, input_json: Dict[str, Any], data_dzn: str, model_mzn: str, output_json: Dict[str, Any]) -> str:
        """
        Use the analysis to improve the code.
        Args:
            original_code: The original generated code
            analysis: The analysis of differences
            input_json: The input JSON
            data_dzn: The data file content
            model_mzn: The MiniZinc model content
            output_json: The expected output
        Returns:
            Improved code
        """
        prompt = f"""Based on the following analysis of differences between the generated solution and expected solution, improve the Python code.

Original Code:
{original_code}

Analysis of Differences:
{analysis}

Problem Description:
{input_json['description']}

Data File (.dzn):
{data_dzn}

MiniZinc Model:
{model_mzn}

Expected Output Format:
{json.dumps(output_json, indent=2)}

Please:
1. Address the specific issues identified in the analysis
2. Implement the suggested improvements
3. Ensure the output format matches exactly what is expected
4. Keep the code clean and well-structured
5. Make sure all variables are properly defined
6. Use explicit loops instead of list comprehensions

Generate the improved Python code that should better match the expected output."""

        client = OpenAI()
        response = client.chat.completions.create(
            model="gpt-4-turbo-preview",
            messages=[{"role": "user", "content": prompt}],
            temperature=0.1
        )
        return response.choices[0].message.content

    def process_example(self, example: Dict[str, Any]) -> None:
        """
        Process a single example from the dataset.
        Args:
            example: The example to process
        """
        try:
            # Extract data from example
            input_json = json.loads(example['input.json'])
            data_dzn = example['data.dzn']
            model_mzn = example.get('model.mzn', '')  # Get model.mzn if it exists
            output_json = json.loads(example['output.json'])
            
            # Get metadata
            metadata = input_json.get('metadata', {})
            problem_id = metadata.get('identifier', metadata.get('id', 'unknown'))  # Try both identifier and id
            problem_name = metadata.get('name', 'unknown')
            domain = metadata.get('domain', 'unknown')
            objective = metadata.get('objective', 'unknown')
            
            # Check if this problem was already solved successfully
            if os.path.exists(os.path.join('output', 'models', f'{problem_id}.py')):
                print(f"\nSkipping example {problem_id}: {problem_name} - Already solved successfully")
                return
            
            print(f"\nProcessing example {problem_id}: {problem_name}")
            print(f"Domain: {domain}")
            print(f"Objective: {objective}")
            
            # Initialize OpenAI client
            client = OpenAI()
            
            # Generate Python model
            prompt = create_python_model_prompt(input_json, data_dzn, model_mzn, output_json)
            response = client.chat.completions.create(
                model="gpt-4-turbo-preview",
                messages=[{"role": "user", "content": prompt}],
                temperature=0.1
            )
            generated_code = response.choices[0].message.content
            
            # Clean the code before saving
            cleaned_code = clean_code(generated_code)
            
            # Execute generated code with retries for execution errors
            max_retries = 5
            current_code = cleaned_code
            current_error = None
            all_analyses = []
            
            for attempt in range(max_retries):
                print(f"\nExecution attempt {attempt + 1}/{max_retries}")
                print("Executing code...")
                result, error = execute_generated_code(current_code, data_dzn)
                
                if error:
                    print(f"❌ Error: {error}")
                    if attempt < max_retries - 1:  # If not the last attempt
                        print("Analyzing error and improving code...")
                        analysis = self.analyze_differences(None, output_json, input_json['description'], current_code)
                        all_analyses.append(analysis)
                        print("\nAnalysis of error:")
                        print(analysis)
                        
                        print(f"\nImproving code based on error analysis. Retry number: {attempt}...")
                        improved_code = self.improve_code(current_code, analysis, input_json, data_dzn, model_mzn, output_json)
                        current_code = clean_code(improved_code)
                        current_error = error
                        continue
                    else:
                        # Last attempt failed
                        print("❌ Could not fix execution errors after all attempts")
                        self.results_manager.save_result(
                            problem_id=problem_id,
                            problem_name=problem_name,
                            domain=domain,
                            objective=objective,
                            success=False,
                            error=f"Failed after {max_retries} execution attempts. Last error: {error}\n\nAll Analyses:\n" + "\n---\n".join(all_analyses),
                            generated_code=current_code,
                            expected_output=output_json,
                            actual_output=None
                        )
                        return
                
                print("✅ Code executed successfully")
                
                if compare_results(result, output_json):
                    print("✅ Solution matches expected output!")
                    # Save successful model
                    self.results_manager.save_result(
                        problem_id=problem_id,
                        problem_name=problem_name,
                        domain=domain,
                        objective=objective,
                        success=True,
                        error=None,
                        generated_code=current_code,
                        expected_output=output_json,
                        actual_output=result
                    )
                    return
                
                print("❌ Solution does not match expected output")
                current_result = result
                
                # Try up to 5 improvements for solution matching
                max_self_imp_iters = 5
                for imp_attempt in range(max_self_imp_iters):
                    print(f"\nImprovement attempt {imp_attempt + 1}/{max_self_imp_iters}")
                    print("Analyzing differences...")
                    analysis = self.analyze_differences(current_result, output_json, input_json['description'], current_code)
                    all_analyses.append(analysis)
                    print("\nAnalysis of differences:")
                    print(analysis)
                    
                    print("\nImproving code based on analysis...")
                    improved_code = self.improve_code(current_code, analysis, input_json, data_dzn, model_mzn, output_json)
                    improved_code = clean_code(improved_code)
                    
                    print("Executing improved code...")
                    improved_result, improved_error = execute_generated_code(improved_code, data_dzn)
                    
                    if improved_error:
                        print(f"❌ Error in improved code: {improved_error}")
                        current_error = improved_error
                        break
                    
                    print("✅ Improved code executed successfully")
                    if compare_results(improved_result, output_json):
                        print("✅ Improved solution matches expected output!")
                        # Save successful improved model
                        self.results_manager.save_result(
                            problem_id=problem_id,
                            problem_name=problem_name,
                            domain=domain,
                            objective=objective,
                            success=True,
                            error=None,
                            generated_code=improved_code,
                            expected_output=output_json,
                            actual_output=improved_result
                        )
                        return  # Exit if we found a successful solution
                    
                    # Update current state for next iteration
                    current_code = improved_code
                    current_result = improved_result
                
                # If we get here, we either had an error or didn't find a matching solution
                print("❌ Could not find a matching solution after all improvement attempts")
                # Save the final state
                self.results_manager.save_result(
                    problem_id=problem_id,
                    problem_name=problem_name,
                    domain=domain,
                    objective=objective,
                    success=False,
                    error=f"Failed after {max_self_imp_iters} improvement attempts. Last error: {current_error}\n\nAll Analyses:\n" + "\n---\n".join(all_analyses),
                    generated_code=current_code,
                    expected_output=output_json,
                    actual_output=current_result
                )
            
        except Exception as e:
            print(f"❌ Error processing example: {str(e)}")
            #print("Stack trace:")
            #print(self.get_stack_trace())

    def get_stack_trace(self) -> str:
        """Get the current stack trace."""
        try:
            return ''.join(traceback.format_stack())
        except Exception as e:
            return f"Error getting stack trace: {str(e)}"
    
    def process_all_examples(self, start_idx: int = 0, end_idx: int = None) -> None:
        """Process all examples in the dataset."""
        if not self.examples:
            print("No examples to process!")
            return
            
        if end_idx is None:
            end_idx = len(self.examples)
            
        print(f"\nProcessing examples {start_idx} to {end_idx}...")
        for i, example in enumerate(tqdm(self.examples[start_idx:end_idx], desc="Processing examples")):
            print(f"\nExample {i + 1}/{end_idx - start_idx}")
            self.process_example(example)
            
        print("\nProcessing complete!")
        print(f"Results saved to: {self.results_manager.results_file}")
        print(f"Successful models saved to: {self.results_manager.models_dir}")
        print(f"Failed models saved to: {self.results_manager.failed_models_dir}")

def dump_dataset(dataset, output_dir: str = "TEXT2ZINC") -> None:
    """
    Dumps the loaded dataset to disk.
    
    Args:
        dataset: The loaded dataset from Hugging Face
        output_dir: Directory where the dataset will be saved
    """
    print("Dumping dataset to disk...")
    
    # Create output directory
    os.makedirs(output_dir, exist_ok=True)
    
    # Process each split
    for split_name, split_data in dataset.items():
        print(f"\nProcessing {split_name} split...")
        split_dir = os.path.join(output_dir, split_name)
        os.makedirs(split_dir, exist_ok=True)
        
        # Process each example
        for i, example in enumerate(split_data):
            example_dir = os.path.join(split_dir, f"example_{i}")
            os.makedirs(example_dir, exist_ok=True)
            
            # Save each field if it exists
            for field, value in example.items():
                if value is None:
                    continue
                    
                if field == 'input.json' and value:
                    try:
                        with open(os.path.join(example_dir, "input.json"), 'w') as f:
                            json.dump(json.loads(value), f, indent=2)
                    except Exception as e:
                        print(f"Warning: Could not save input.json for example {i}: {e}")
                
                elif field == 'output.json' and value:
                    try:
                        with open(os.path.join(example_dir, "output.json"), 'w') as f:
                            json.dump(json.loads(value), f, indent=2)
                    except Exception as e:
                        print(f"Warning: Could not save output.json for example {i}: {e}")
                
                elif field == 'data.dzn' and value:
                    try:
                        with open(os.path.join(example_dir, "data.dzn"), 'w') as f:
                            f.write(value)
                    except Exception as e:
                        print(f"Warning: Could not save data.dzn for example {i}: {e}")
                
                elif field == 'model.mzn' and value:
                    try:
                        with open(os.path.join(example_dir, "model.mzn"), 'w') as f:
                            f.write(value)
                    except Exception as e:
                        print(f"Warning: Could not save model.mzn for example {i}: {e}")
                
                elif field == 'metadata' and value:
                    try:
                        with open(os.path.join(example_dir, "metadata.json"), 'w') as f:
                            json.dump(value, f, indent=2)
                    except Exception as e:
                        print(f"Warning: Could not save metadata.json for example {i}: {e}")
            
            if (i + 1) % 10 == 0:
                print(f"Processed {i + 1} examples...")
    
    print(f"\nDataset saved to {output_dir}")

def main():
    # Initialize dataset manager
    dataset_manager = DatasetManager()
    
    # Load and process examples
    dataset_manager.load_dataset()
    dataset_manager.filter_verified_examples()
    
    # Dump dataset to disk only if it doesn't exist
    if not os.path.exists("TEXT2ZINC"):
        print("Dataset not found locally, downloading...")
        dump_dataset(dataset_manager.dataset)
    else:
        print("Using local dataset from TEXT2ZINC directory")
    
    # Process first 10 examples
    dataset_manager.process_all_examples(start_idx=0, end_idx=10)

if __name__ == "__main__":
    main() 