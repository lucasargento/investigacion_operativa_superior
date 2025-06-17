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

    # Define the objective
    objective = solver.Objective()
    for i in range(N):
        illumination = 0
        for j in range(M):
            illumination += Coefficients[i][j] * power[j]
        error = solver.NumVar(0, solver.infinity(), f'error_{i}')
        solver.Add(error >= illumination - DesiredIlluminations[i])
        solver.Add(error >= -(illumination - DesiredIlluminations[i]))
        objective.SetCoefficient(error, 1)
    objective.SetMinimization()

    # Solve
    status = solver.Solve()

    # Create solution dictionary
    solution = {}
    if status == pywraplp.Solver.OPTIMAL:
        # Format the objective value to match the expected precision
        solution['_objective'] = round(objective.Value(), 2)

    return solution

if __name__ == '__main__':
    result = solve()
    print(json.dumps(result, indent=2))