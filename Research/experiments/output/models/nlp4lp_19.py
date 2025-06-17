import json
from ortools.linear_solver import pywraplp

def solve():
    # Create the solver
    solver = pywraplp.Solver.CreateSolver('SCIP')

    # Define all data from .dzn file as Python variables
    M = 6  # Months
    I = 5  # Types of oils
    BuyPrice = [
        [110, 120, 130, 110, 115],
        [130, 130, 110, 90, 115],
        [110, 140, 130, 100, 95],
        [120, 110, 120, 120, 125],
        [100, 120, 150, 110, 105],
        [90, 100, 140, 80, 135]
    ]
    SellPrice = 150
    IsVegetable = [True, True, False, False, False]
    MaxVegetableRefiningPerMonth = 200
    MaxNonVegetableRefiningPerMonth = 250
    StorageSize = 1000
    StorageCost = 5
    MinHardness = 3
    MaxHardness = 6
    Hardness = [8.8, 6.1, 2.0, 4.2, 5.0]
    InitialAmount = 500

    # Define all variables
    # Amount of each oil type bought each month
    buy = {}
    for i in range(I):
        for m in range(M):
            buy[i, m] = solver.NumVar(0, solver.infinity(), f'buy_{i}_{m}')
    
    # Amount of each oil type used each month
    use = {}
    for i in range(I):
        for m in range(M):
            use[i, m] = solver.NumVar(0, solver.infinity(), f'use_{i}_{m}')
    
    # Amount of each oil type stored at the end of each month
    store = {}
    for i in range(I):
        for m in range(M):
            store[i, m] = solver.NumVar(0, solver.infinity(), f'store_{i}_{m}')
    
    # Total amount of oil produced each month
    produce = [solver.NumVar(0, solver.infinity(), f'produce_{m}') for m in range(M)]
    
    # Constraints
    # Initial storage constraint
    for i in range(I):
        solver.Add(store[i, 0] == InitialAmount + buy[i, 0] - use[i, 0])
    
    # Storage balance for subsequent months
    for i in range(I):
        for m in range(1, M):
            solver.Add(store[i, m] == store[i, m-1] + buy[i, m] - use[i, m])
    
    # Storage capacity constraint
    for m in range(M):
        solver.Add(sum(store[i, m] for i in range(I)) <= StorageSize)
    
    # Refining capacity constraints
    for m in range(M):
        solver.Add(sum(use[i, m] for i in range(I) if IsVegetable[i]) <= MaxVegetableRefiningPerMonth)
        solver.Add(sum(use[i, m] for i in range(I) if not IsVegetable[i]) <= MaxNonVegetableRefiningPerMonth)
    
    # Hardness constraints
    for m in range(M):
        solver.Add(sum(use[i, m] * Hardness[i] for i in range(I)) >= MinHardness * sum(use[i, m] for i in range(I)))
        solver.Add(sum(use[i, m] * Hardness[i] for i in range(I)) <= MaxHardness * sum(use[i, m] for i in range(I)))
    
    # Final storage equals initial storage
    for i in range(I):
        solver.Add(store[i, M-1] == InitialAmount)
    
    # Production amount
    for m in range(M):
        solver.Add(produce[m] == sum(use[i, m] for i in range(I)))
    
    # Set objective
    objective = solver.Objective()
    for m in range(M):
        for i in range(I):
            objective.SetCoefficient(buy[i, m], -BuyPrice[m][i])
            objective.SetCoefficient(use[i, m], SellPrice)
        for i in range(I):
            objective.SetCoefficient(store[i, m], -StorageCost)
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