from ortools.linear_solver import pywraplp
import json

def solve():
    # Create the solver
    solver = pywraplp.Solver.CreateSolver('SCIP')

    # Define all data from .dzn file as Python variables
    O = 2  # Number of oil types
    P = 2  # Number of products
    L = 3  # Number of processes
    Allocated = [8000, 5000]  # Allocated barrels of each oil type
    Price = [38, 33]  # Price of each product
    Input = [[3, 5], [1, 1], [5, 3]]  # Input matrix (processes x oil types)
    Output = [[4, 3], [1, 1], [3, 4]]  # Output matrix (processes x products)
    Cost = [51, 11, 40]  # Cost per barrel of product produced by each process

    # Define all variables
    # Number of times each process is executed
    x = [solver.NumVar(0.0, solver.infinity(), f'x_{i}') for i in range(L)]

    # Add constraints
    # Constraint for oil usage not exceeding allocated amount
    for o in range(O):
        solver.Add(sum(Input[l][o] * x[l] for l in range(L)) <= Allocated[o])

    # Objective: Maximize revenue
    objective = solver.Objective()
    for p in range(P):
        for l in range(L):
            profit_per_barrel = Price[p] * Output[l][p] - Cost[l]
            objective.SetCoefficient(x[l], profit_per_barrel)
    objective.SetMaximization()

    # Solve
    status = solver.Solve()

    # Create solution dictionary
    solution = {}
    if status == pywraplp.Solver.OPTIMAL:
        solution['_objective'] = objective.Value()

    return solution

if __name__ == '__main__':
    result = solve()
    print(json.dumps(result, indent=2))