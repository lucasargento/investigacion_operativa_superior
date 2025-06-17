from ortools.linear_solver import pywraplp
import json

def solve():
    # Create the solver
    solver = pywraplp.Solver.CreateSolver('SCIP')

    # Define all data from .dzn file as Python variables
    TotalAircraft = 4
    TotalRoutes = 4
    Availability = [500, 600, 700, 800]
    Demand = [200, 300, 400, 500]
    Capacity = [
        [100, 200, 300, 400],  # Aircraft 1 capacities for Routes 1..4
        [200, 300, 400, 500],  # Aircraft 2
        [300, 400, 500, 600],  # Aircraft 3
        [400, 500, 600, 700]   # Aircraft 4
    ]
    Costs = [
        [10, 20, 30, 40],  # Aircraft 1 costs for Routes 1..4
        [20, 30, 40, 50],  # Aircraft 2
        [30, 40, 50, 60],  # Aircraft 3
        [40, 50, 60, 70]   # Aircraft 4
    ]

    # Define all variables
    Assignment = {}
    for i in range(TotalAircraft):
        for j in range(TotalRoutes):
            Assignment[i, j] = solver.BoolVar(f'Assignment_{i}_{j}')

    # Add constraints
    # (C1) Ensure each route meets its demand exactly
    for j in range(TotalRoutes):
        solver.Add(solver.Sum([Assignment[i, j] for i in range(TotalAircraft)]) == Demand[j])

    # (C2) Ensure that no aircraft is assigned to more routes than it is available for
    for i in range(TotalAircraft):
        solver.Add(solver.Sum([Assignment[i, j] for j in range(TotalRoutes)]) <= Availability[i])

    # (C3) Ensure aircraft can only be assigned to routes where they have capacity
    for i in range(TotalAircraft):
        for j in range(TotalRoutes):
            solver.Add(Assignment[i, j] * Capacity[i][j] > 0)

    # Set objective
    TotalCost = solver.Objective()
    for i in range(TotalAircraft):
        for j in range(TotalRoutes):
            TotalCost.SetCoefficient(Assignment[i, j], Costs[i][j])
    TotalCost.SetMinimization()

    # Solve
    status = solver.Solve()

    # Create solution dictionary
    solution = {}
    if status == pywraplp.Solver.OPTIMAL:
        # Convert solution to dictionary format
        solution['x'] = []
        for i in range(TotalAircraft):
            for j in range(TotalRoutes):
                solution['x'].append(int(Assignment[i, j].solution_value()))
        solution['_objective'] = TotalCost.Value()

    return solution

if __name__ == '__main__':
    result = solve()
    print(json.dumps(result, indent=2))