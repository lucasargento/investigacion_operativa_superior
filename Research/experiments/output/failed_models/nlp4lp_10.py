from ortools.linear_solver import pywraplp
import json

def solve():
    # Create the solver
    solver = pywraplp.Solver.CreateSolver('SCIP')

    # Define all data from .dzn file as Python variables
    N = 3  # Number of segments
    M = 2  # Number of lamps
    Coefficients = [
        [0.5, 0.3],
        [0.2, 0.4],
        [0.1, 0.6]
    ]
    DesiredIlluminations = [14, 3, 12]

    # Define all variables
    power = []
    for j in range(M):
        power.append(solver.NumVar(0, solver.infinity(), f'power_{j}'))

    # Define auxiliary variables for absolute error
    abs_error = []
    for i in range(N):
        abs_error.append(solver.NumVar(0, solver.infinity(), f'abs_error_{i}'))

    # Add constraints for absolute error calculation
    for i in range(N):
        actual_illumination = solver.Sum([Coefficients[i][j] * power[j] for j in range(M)])
        solver.Add(abs_error[i] >= actual_illumination - DesiredIlluminations[i])
        solver.Add(abs_error[i] >= -(actual_illumination - DesiredIlluminations[i]))

    # Set objective
    objective = solver.Objective()
    for i in range(N):
        objective.SetCoefficient(abs_error[i], 1)
    objective.SetMinimization()

    # Solve
    status = solver.Solve()

    # Create solution dictionary
    solution = {}
    if status == pywraplp.Solver.OPTIMAL:
        # Convert solution to dictionary format
        solution['_objective'] = objective.Value()

    return solution

if __name__ == '__main__':
    result = solve()
    print(json.dumps(result, indent=2))