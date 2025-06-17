from ortools.linear_solver import pywraplp
import json

def solve():
    # Create the solver
    solver = pywraplp.Solver.CreateSolver('SCIP')

    # Define all data from .dzn file as Python variables
    K = 3  # Number of industries
    T = 5  # Total number of years, including the build-up phase
    InputOne = [[0.1, 0.1, 0.2], [0.5, 0.1, 0.1], [0.5, 0.2, 0.2]]
    ManpowerOne = [0.6, 0.3, 0.2]
    InputTwo = [[0.0, 0.1, 0.2], [0.7, 0.1, 0.1], [0.9, 0.2, 0.2]]
    ManpowerTwo = [0.4, 0.2, 0.1]
    Stock = [150, 80, 100]
    Capacity = [300, 350, 280]
    ManpowerLimit = 470  # Adjusted to reflect the correct problem statement

    # Define variables for production, capacity, and updated stocks over time
    production = {}
    capacity = {}
    updated_stocks = {}
    for t in range(T):
        for k in range(K):
            production[t, k] = solver.NumVar(0, solver.infinity(), f'production_{t}_{k}')
            capacity[t, k] = solver.NumVar(0, Capacity[k] if t == 0 else solver.infinity(), f'capacity_{t}_{k}')
            updated_stocks[t, k] = solver.NumVar(0, solver.infinity(), f'updated_stocks_{t}_{k}')

    # Initialize stocks for year 0
    for k in range(K):
        solver.Add(updated_stocks[0, k] == Stock[k])

    # Adjust manpower constraints to allow more flexible allocation
    for t in range(T):
        manpower_usage_production = sum(production[t, k] * ManpowerOne[k] for k in range(K))
        if t >= 2:
            manpower_usage_capacity = sum((capacity[t, k] - capacity[t-1, k]) * ManpowerTwo[k] for k in range(K))
        else:
            manpower_usage_capacity = 0
        solver.Add(manpower_usage_production + manpower_usage_capacity <= ManpowerLimit)

    # Adjust capacity increase logic to reflect immediate increases
    for t in range(1, T):
        for k in range(K):
            capacity_increase = sum(production[t-1, j] * InputTwo[j][k] for j in range(K))
            solver.Add(capacity[t, k] >= capacity[t-1, k] + capacity_increase)

    # Ensure production does not exceed capacity
    for t in range(T):
        for k in range(K):
            solver.Add(production[t, k] <= capacity[t, k])

    # Adjust stock updates to correctly account for all inflows and outflows
    for t in range(1, T):
        for k in range(K):
            input_requirement = sum(production[t-1, j] * InputOne[j][k] for j in range(K))
            stock_increase = sum(production[t-1, j] * InputTwo[j][k] for j in range(K))
            solver.Add(input_requirement <= updated_stocks[t-1, k])
            solver.Add(updated_stocks[t, k] == updated_stocks[t-1, k] + stock_increase - production[t, k])

    # Set objective: Maximize total production in the last two years
    objective = solver.Objective()
    for t in range(T-2, T):
        for k in range(K):
            objective.SetCoefficient(production[t, k], 1)
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