from ortools.linear_solver import pywraplp
import json

def solve():
    # Create the solver
    solver = pywraplp.Solver.CreateSolver('SCIP')

    # Define all data from .dzn file as Python variables
    P = 2
    num_customers = 4
    num_warehouses = 3
    Demand = [100.0, 80.0, 80.0, 70.0]
    Distance = [
        [2.0, 10.0, 50.0],
        [2.0, 10.0, 52.0],
        [50.0, 60.0, 3.0],
        [40.0, 60.0, 1.0]
    ]

    # Define all variables
    OpenWarehouse = [solver.BoolVar(f'OpenWarehouse_{w}') for w in range(num_warehouses)]
    ShipToCustomer = {}
    for c in range(num_customers):
        for w in range(num_warehouses):
            ShipToCustomer[c, w] = solver.BoolVar(f'ShipToCustomer_{c}_{w}')

    # Objective
    z = solver.Sum(Demand[c] * Distance[c][w] * ShipToCustomer[c, w] for c in range(num_customers) for w in range(num_warehouses))
    solver.Minimize(z)

    # Constraints
    # Each customer is served by exactly one warehouse
    for c in range(num_customers):
        solver.Add(solver.Sum(ShipToCustomer[c, w] for w in range(num_warehouses)) == 1)

    # Exactly P warehouses are opened
    solver.Add(solver.Sum(OpenWarehouse[w] for w in range(num_warehouses)) == P)

    # A customer can be served by a warehouse only if it is open
    for c in range(num_customers):
        for w in range(num_warehouses):
            solver.Add(ShipToCustomer[c, w] <= OpenWarehouse[w])

    # Solve
    status = solver.Solve()

    # Create solution dictionary
    solution = {}
    if status == pywraplp.Solver.OPTIMAL:
        solution['OpenWarehouse'] = [int(OpenWarehouse[w].solution_value()) for w in range(num_warehouses)]
        solution['ShipToCustomer'] = [[int(ShipToCustomer[c, w].solution_value()) for w in range(num_warehouses)] for c in range(num_customers)]
        solution['_objective'] = z.solution_value()

    return solution

if __name__ == '__main__':
    result = solve()
    print(json.dumps(result, indent=2))