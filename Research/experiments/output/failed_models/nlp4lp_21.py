from ortools.linear_solver import pywraplp
import json

def solve():
    # Create the solver
    solver = pywraplp.Solver.CreateSolver('SCIP')

    # Define all data from .dzn file as Python variables
    M = 5
    K = 7
    I = 6
    NumMachines = [4, 2, 3, 1, 1]
    Profit = [10, 6, 8, 4, 11, 9, 3]
    Time = [
        [0.5, 0.1, 0.2, 0.05, 0.0, 0.7, 0.2, 0.0, 0.03, 0.0, 0.0, 0.0, 0.8, 0.0, 0.01, 0.0, 0.3, 0.0, 0.07, 0.0, 0.3, 0.0, 0.0, 0.1, 0.05, 0.5, 0.0, 0.6, 0.08, 0.05],
        [1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 2, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
        [500, 600, 300, 200, 0, 500, 1000, 500, 600, 300, 100, 500, 300, 200, 0, 400, 500, 100, 300, 0, 0, 500, 100, 300, 800, 400, 500, 200, 1000, 1100, 200, 300, 400, 0, 300, 500, 100, 150, 100, 100, 0, 60]
    ]
    StorePrice = 0.5
    KeepQuantity = 100
    WorkHours = 8.0

    # Flatten Time and Maintain for easier access
    Time = [Time[0][i:i+M] for i in range(0, len(Time[0]), M)]
    Maintain = [Time[1][i:i+I] for i in range(0, len(Time[1]), I)]
    Limit = [Time[2][i:i+I] for i in range(0, len(Time[2]), I)]

    # Define all variables
    # Production quantity of product k in month i
    prod = {}
    for k in range(K):
        for i in range(I):
            prod[k, i] = solver.IntVar(0, solver.infinity(), f'prod_{k}_{i}')
    
    # Storage quantity of product k at the end of month i
    store = {}
    for k in range(K):
        for i in range(I):
            store[k, i] = solver.IntVar(0, KeepQuantity, f'store_{k}_{i}')

    # Add constraints
    # Production time constraint for each machine and month
    for m in range(M):
        for i in range(I):
            solver.Add(solver.Sum([Time[k][m] * prod[k, i] for k in range(K)]) <= (WorkHours * 24 * (NumMachines[m] - Maintain[m][i])))

    # Production limit constraint
    for k in range(K):
        for i in range(I):
            solver.Add(prod[k, i] <= Limit[k][i])

    # Storage balance and limit constraint
    for k in range(K):
        for i in range(I):
            if i == 0:
                solver.Add(prod[k, i] - store[k, i] == 0)
            else:
                solver.Add(prod[k, i] + store[k, i-1] - store[k, i] == 0)

    # Set objective
    objective = solver.Objective()
    for k in range(K):
        for i in range(I):
            objective.SetCoefficient(prod[k, i], Profit[k])
            objective.SetCoefficient(store[k, i], -StorePrice)
    objective.SetMaximization()

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