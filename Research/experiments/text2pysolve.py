import json
import os
import tempfile
import importlib.util
import numpy as np
from typing import Dict, Any, Tuple, Optional, Union, List
import openai
from pathlib import Path
from dotenv import load_dotenv
import pymzn
import math
import csv
from datetime import datetime

# Load environment variables at the top of the file
load_dotenv()

def create_python_model_prompt(input_json: Dict[str, Any], data_dzn: str, model_mzn: str, output_json: Dict[str, Any]) -> str:
    """
    Create a prompt for the OpenAI API to generate a Python model.
    Args:
        input_json: The input JSON containing the problem description
        data_dzn: The data file content
        model_mzn: The MiniZinc model content
        output_json: The expected output format
    Returns:
        The prompt for the OpenAI API
    """
    prompt = f"""
        Translate the following MiniZinc model into a Python model using OR-Tools.
        The generated code MUST be pure Python and executable as-is.
        The code MUST include a solve() function that returns the solution as a dictionary.

        CRITICAL REQUIREMENTS:
        1. The code MUST include a solve() function that returns the solution as a dictionary
        2. The solve() function MUST return a dictionary with the same structure as the expected output
        3. All variables MUST be defined before use
        4. NO list comprehensions with undefined variables
        5. When possible, use explicit loops instead of list comprehensions
        6. Define all indices before use
        7. The code MUST be a complete, self-contained Python script
        8. The code MUST NOT read or parse any files
        9. The code MUST convert the .dzn data directly into Python variables

        Example structure:
        ```python
        from ortools.linear_solver import pywraplp

        def solve():
            # Create the solver
            solver = pywraplp.Solver.CreateSolver('SCIP')
            
            # Define all data from .dzn file as Python variables
            TotalAircraft = 10
            TotalRoutes = 5
            Availability = [1, 1, 1, 1, 1]
            Demand = [100, 200, 150, 300, 250]
            Capacity = [500, 400, 300, 600, 450]
            
            # Define all variables
            x = {{}}
            for i in range(TotalAircraft):
                for j in range(TotalRoutes):
                    x[i, j] = solver.BoolVar(f'x_{{i}}_{{j}}')
            
            # Add constraints
            for i in range(TotalAircraft):
                solver.Add(sum(x[i, j] for j in range(TotalRoutes)) <= 1)
            
            for j in range(TotalRoutes):
                solver.Add(sum(x[i, j] for i in range(TotalAircraft)) >= Demand[j])
            
            # Set objective
            objective = solver.Objective()
            for i in range(TotalAircraft):
                for j in range(TotalRoutes):
                    objective.SetCoefficient(x[i, j], Capacity[j])
            objective.SetMaximization()
            
            # Solve
            status = solver.Solve()
            
            # Create solution dictionary
            solution = {{}}
            if status == pywraplp.Solver.OPTIMAL:
                # Convert solution to dictionary format
                solution['x'] = []
                for i in range(TotalAircraft):
                    row = []
                    for j in range(TotalRoutes):
                        row.append(int(x[i, j].solution_value()))
                    solution['x'].append(row)
                solution['_objective'] = objective.Value()
            
            return solution

        if __name__ == '__main__':
            result = solve()
            print(json.dumps(result, indent=2))
        ```
        Given the following:

        Problem Description (natural langugage description of the optimization problem to formulate):
        {input_json['description']}

        Data File (.dzn) (file containing the values of the variables needed for the formulation of the problem):
        {data_dzn}

        MiniZinc Model (An existing model that resolves the proposed problem in the minizinc language, which you should translate to pure python code):
        {model_mzn}

        Expected Output Format (the output format that your python model should match in order to be evaluated correctly):
        {json.dumps(output_json, indent=2)}

        Generate a Python model that follows the example structure and meets all requirements. Reflect and think step by step if needed.
    """
    return prompt

def clean_code(code: str) -> str:
    """
    Clean the code of any markdown or explanatory text.
    Args:
        code: The code to clean
    Returns:
        The cleaned code
    """
    # Remove markdown code blocks
    if "```python" in code:
        start_idx = code.find("```python") + len("```python")
        end_idx = code.find("```", start_idx)
        if start_idx != -1 and end_idx != -1:
            code = code[start_idx:end_idx]
    elif "```" in code:
        start_idx = code.find("```") + len("```")
        end_idx = code.find("```", start_idx)
        if start_idx != -1 and end_idx != -1:
            code = code[start_idx:end_idx]
    
    # Remove any leading/trailing whitespace
    return code.strip()

def execute_generated_code(code: str, data_dzn: str) -> Tuple[Optional[Dict[str, Any]], Optional[str]]:
    """
    Execute the generated Python code.
    Args:
        code: The generated Python code
        data_dzn: The data file content
    Returns:
        A tuple containing the result and any error message
    """
    try:
        # Clean the code of any markdown
        code = clean_code(code)
        
        # Create a temporary file
        with tempfile.NamedTemporaryFile(suffix='.py', delete=False) as f:
            f.write(code.encode())
            temp_file = f.name
        
        # Create a module from the file
        spec = importlib.util.spec_from_file_location("generated_model", temp_file)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        
        # Execute the solve function
        if not hasattr(module, 'solve'):
            return None, "Generated code does not contain a solve() function"
        
        result = module.solve()
        
        # Clean up
        os.unlink(temp_file)
        
        return result, None
        
    except Exception as e:
        return None, str(e)

def compare_results(generated_result: Optional[Dict[str, Any]], expected_output: Dict[str, Any]) -> bool:
    """
    Compares the generated solution with the expected output.
    
    Args:
        generated_result: Dictionary with the generated solution
        expected_output: Dictionary with the expected output
    """
    if generated_result is None:
        return False

    # Convert keys to lowercase for case-insensitive comparison
    generated_result_lower = {k.lower(): v for k, v in generated_result.items()}
    expected_output_lower = {k.lower(): v for k, v in expected_output.items()}

    # Compare objective value first
    if '_objective' in expected_output_lower and '_objective' in generated_result_lower:
        if not math.isclose(generated_result_lower['_objective'], expected_output_lower['_objective'], rel_tol=1e-5):
            return False

    # Compare other keys (assuming all relevant keys are in expected_output)
    for key, expected_value in expected_output_lower.items():
        if key == '_objective':
            continue
        if key not in generated_result_lower:
            return False
        
        generated_value = generated_result_lower[key]

        # Handle lists/arrays
        if isinstance(expected_value, list) and isinstance(generated_value, list):
            if len(expected_value) != len(generated_value):
                return False
            for i in range(len(expected_value)):
                if isinstance(expected_value[i], (int, float)) and isinstance(generated_value[i], (int, float)):
                    if not math.isclose(expected_value[i], generated_value[i], rel_tol=1e-5):
                        return False
                elif expected_value[i] != generated_value[i]:
                    return False
        elif isinstance(expected_value, (int, float)) and isinstance(generated_value, (int, float)):
            if not math.isclose(expected_value, generated_value, rel_tol=1e-5):
                return False
        elif expected_value != generated_value:
            return False
            
    return True

class ResultsManager:
    def __init__(self, output_dir: str = "output"):
        self.output_dir = output_dir
        self.results_file = os.path.join(output_dir, f"results_{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv")
        self.models_dir = os.path.join(output_dir, "models")
        self.failed_models_dir = os.path.join(output_dir, "failed_models")
        
        # Create directories if they don't exist
        os.makedirs(output_dir, exist_ok=True)
        os.makedirs(self.models_dir, exist_ok=True)
        os.makedirs(self.failed_models_dir, exist_ok=True)
        
        # Create CSV file with headers
        with open(self.results_file, 'w') as f:
            f.write("problem_id,problem_name,domain,objective,success,error,generated_code,expected_output,actual_output\n")
    
    def save_result(self, problem_id: str, problem_name: str, domain: str, objective: str, 
                   success: bool, error: Optional[str], generated_code: str, 
                   expected_output: Dict[str, Any], actual_output: Optional[Dict[str, Any]]) -> None:
        """
        Save the result of a model generation attempt.
        Args:
            problem_id: Unique identifier for the problem
            problem_name: Name of the problem
            domain: Domain of the problem
            objective: Objective of the problem
            success: Whether the model was successfully generated and executed
            error: Error message if any
            generated_code: The generated Python code
            expected_output: The expected output from the MiniZinc model
            actual_output: The actual output from the generated Python code
        """
        # Save the generated code
        if success:
            code_file = os.path.join(self.models_dir, f"{problem_id}.py")
        else:
            code_file = os.path.join(self.failed_models_dir, f"{problem_id}.py")
        
        with open(code_file, 'w') as f:
            f.write(generated_code)
        
        # Save result to CSV
        with open(self.results_file, 'a') as f:
            f.write(f"{problem_id},{problem_name},{domain},{objective},{success},{error},{generated_code},{expected_output},{actual_output}\n")

def evaluate_example(example: Dict[str, Any], results_manager: ResultsManager, max_retries: int = 5) -> Tuple[bool, Optional[str]]:
    """
    Evaluate a single example from the dataset.
    Args:
        example: The example to evaluate
        results_manager: The results manager
        max_retries: Maximum number of retries for code generation
    Returns:
        A tuple containing success status and any error message
    """
    # Extract data from example
    input_json = json.loads(example['input.json'])
    data_dzn = example['data.dzn']
    model_mzn = example.get('model.mzn', '')
    output_json = json.loads(example['output.json'])
    
    # Get metadata
    metadata = input_json.get('metadata', {})
    problem_id = metadata.get('id', 'unknown')
    problem_name = metadata.get('name', 'unknown')
    domain = metadata.get('domain', 'unknown')
    objective = metadata.get('objective', 'unknown')
    
    print(f"\nProcessing example {problem_id}: {problem_name}")
    print(f"Domain: {domain}")
    print(f"Objective: {objective}")
    
    # Initialize OpenAI client
    client = openai.OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
    
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
    
    # Execute generated code
    print("Executing generated code...")
    result, error = execute_generated_code(cleaned_code, data_dzn)
    
    if error:
        print(f"❌ Error: {error}")
        # Save failed model
        results_manager.save_result(
            problem_id=problem_id,
            problem_name=problem_name,
            domain=domain,
            objective=objective,
            success=False,
            error=error,
            generated_code=cleaned_code,
            expected_output=output_json,
            actual_output=None
        )
    else:
        print("✅ Code executed successfully")
        print("\nGenerated solution:")
        print(json.dumps(result, indent=2))
        print("\nExpected solution:")
        print(json.dumps(output_json, indent=2))
        
        if compare_results(result, output_json):
            print("✅ Solution matches expected output!")
            # Save successful model
            results_manager.save_result(
                problem_id=problem_id,
                problem_name=problem_name,
                domain=domain,
                objective=objective,
                success=True,
                error=None,
                generated_code=cleaned_code,
                expected_output=output_json,
                actual_output=result
            )
        else:
            print("❌ Solution does not match expected output")
            # Save model that didn't match expected output
            results_manager.save_result(
                problem_id=problem_id,
                problem_name=problem_name,
                domain=domain,
                objective=objective,
                success=False,
                error="Generated solution does not match expected output",
                generated_code=cleaned_code,
                expected_output=output_json,
                actual_output=result
            )

def main():
    """
    Example usage of the evaluation function.
    """
    # Example data (replace with actual data)
    input_json = {
        "description": "Example optimization problem",
        "parameters": ["param1", "param2"],
        "model_mzn": "model"
    }
    data_dzn = {
        "param1": 10,
        "param2": 20
    }
    output_json = {
        "solution": [1, 2, 3]
    }

    # Run evaluation
    results_manager = ResultsManager()
    success, message = evaluate_example(
        example={
            "id": "example1",
            "input.json": json.dumps(input_json),
            "data.dzn": json.dumps(data_dzn),
            "output.json": json.dumps(output_json)
        },
        results_manager=results_manager
    )

    print(f"Success: {success}")
    if message:
        print(f"Message: {message}")

if __name__ == "__main__":
    main() 