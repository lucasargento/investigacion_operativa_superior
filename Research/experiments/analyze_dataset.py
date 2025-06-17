import os
import json
from collections import defaultdict

def analyze_dataset(dataset_path='text2zinc'):
    # Initialize counters
    total_examples = 0
    file_counts = defaultdict(int)
    examples_with_all_files = 0
    
    # Walk through the dataset directory
    for root, dirs, files in os.walk(dataset_path):
        # Skip if not a leaf directory (contains subdirectories)
        if dirs:
            continue
            
        # Check if this is an example directory (contains any of our target files)
        has_input = 'input.json' in files
        has_output = 'output.json' in files
        has_model = 'model.mzn' in files
        has_data = 'data.dzn' in files
        
        if any([has_input, has_output, has_model, has_data]):
            total_examples += 1
            
            # Count files
            if has_input:
                file_counts['input.json'] += 1
            if has_output:
                file_counts['output.json'] += 1
            if has_model:
                file_counts['model.mzn'] += 1
            if has_data:
                file_counts['data.dzn'] += 1
                
            # Check if example has all required files
            if all([has_input, has_output, has_model, has_data]):
                examples_with_all_files += 1
                
                # Print example details
                print(f"\nExample in {root}:")
                try:
                    with open(os.path.join(root, 'input.json'), 'r') as f:
                        input_data = json.load(f)
                        metadata = input_data.get('metadata', {})
                        print(f"  ID: {metadata.get('id', 'unknown')}")
                        print(f"  Name: {metadata.get('name', 'unknown')}")
                        print(f"  Domain: {metadata.get('domain', 'unknown')}")
                        print(f"  Objective: {metadata.get('objective', 'unknown')}")
                except Exception as e:
                    print(f"  Error reading input.json: {e}")
    
    # Print summary
    print("\nDataset Analysis Summary:")
    print(f"Total examples found: {total_examples}")
    print("\nFile counts:")
    for file_type, count in file_counts.items():
        print(f"  {file_type}: {count}")
    print(f"\nExamples with all required files: {examples_with_all_files}")
    print(f"Examples missing some files: {total_examples - examples_with_all_files}")

if __name__ == "__main__":
    analyze_dataset() 