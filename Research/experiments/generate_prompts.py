import os
import json
from pathlib import Path

def create_prompt(example_path):
    """Create a prompt for a single example."""
    files = os.listdir(example_path)
    
    # Get example number from directory name
    dir_name = os.path.basename(example_path)
    if dir_name.startswith('example_'):
        example_num = dir_name.split('_')[1]  # Get the number after 'example_'
    else:
        example_num = 'unknown'
    
    # Get metadata and problem info
    input_data = {}
    if 'input.json' in files:
        with open(os.path.join(example_path, 'input.json'), 'r') as f:
            input_data = json.load(f)
    
    metadata = input_data.get('metadata', {})
    problem_name = metadata.get('name', 'unknown')
    domain = metadata.get('domain', 'unknown')
    objective = metadata.get('objective', 'unknown')
    description = input_data.get('description', '')
    
    # Build the prompt
    prompt = f"""You are an expert in translating MiniZinc models to Python using OR-Tools. Your task is to translate the following optimization problem:

Problem Information:
- Example Number: {example_num}
- Name: {problem_name}
- Domain: {domain}
- Objective: {objective}

Problem Description:
{description}

"""

    # Add input data if available
    if 'data.dzn' in files:
        with open(os.path.join(example_path, 'data.dzn'), 'r') as f:
            data_content = f.read()
        prompt += f"\nInput Data (data.dzn):\n{data_content}\n"

    # Add model if available
    if 'model.mzn' in files:
        with open(os.path.join(example_path, 'model.mzn'), 'r') as f:
            model_content = f.read()
        prompt += f"\nMiniZinc Model:\n{model_content}\n"
    else:
        prompt += "\nNo MiniZinc model is provided. Please first generate a MiniZinc model based on the problem description and input data, and then translate it to Python using OR-Tools.\n"

    # Add expected output if available
    if 'output.json' in files:
        with open(os.path.join(example_path, 'output.json'), 'r') as f:
            output_content = f.read()
        prompt += f"\nExpected Output:\n{output_content}\n"

    # Add instructions
    prompt += """
Instructions:
1. If a MiniZinc model is provided, translate it directly to Python using OR-Tools.
2. If no MiniZinc model is provided, first create a MiniZinc model and then translate it to Python.
3. The Python code should be complete and executable as-is.
4. Include all necessary imports and dependencies.
5. Define all variables before use.
6. Use explicit loops instead of list comprehensions.
7. Ensure the solution matches the expected output format.
8. Include comments explaining key parts of the implementation.

Please provide the complete Python code that solves this optimization problem using OR-Tools."""

    return prompt, f"example_{example_num}_{problem_name.replace(' ', '_')}"

def generate_prompts(dataset_path='text2zinc', output_path='prompts'):
    """Generate prompts for all examples and save them as text files."""
    # Create output directory if it doesn't exist
    Path(output_path).mkdir(exist_ok=True)
    
    # Walk through the dataset
    for root, dirs, files in os.walk(dataset_path):
        # Skip if not a leaf directory
        if dirs:
            continue
            
        # Check if this is an example directory
        if any(f in files for f in ['input.json', 'model.mzn', 'data.dzn']):
            prompt, filename = create_prompt(root)
            
            # Save prompt to file
            output_file = os.path.join(output_path, f"{filename}.txt")
            with open(output_file, 'w') as f:
                f.write(prompt)
            
            print(f"Generated prompt for {filename}")

if __name__ == "__main__":
    generate_prompts() 