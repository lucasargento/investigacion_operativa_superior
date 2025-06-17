from ortools.sat.python import cp_model
import json

def solve():
    model = cp_model.CpModel()

    # Data from .dzn file
    n = 10
    X = -1  # Representation of a blank
    puzzle = [
        [0,X,X,X,X,X,3,4,X,3],
        [X,X,X,4,X,X,X,7,X,X],
        [X,X,5,X,2,2,X,4,X,3],
        [4,X,6,6,X,2,X,X,X,X],
        [X,X,X,X,3,3,X,X,3,X],
        [X,X,8,X,X,4,X,X,X,X],
        [X,9,X,7,X,X,X,X,5,X],
        [X,X,X,7,5,X,X,3,3,0],
        [X,X,X,X,X,X,X,X,X,X],
        [4,4,X,X,2,3,3,4,3,X]
    ]

    # Variables
    grid = {}
    for i in range(n):
        for j in range(n):
            grid[i, j] = model.NewBoolVar(f'grid_{i}_{j}')

    # Constraints
    for i in range(n):
        for j in range(n):
            if puzzle[i][j] != X:
                # Calculate the sum of the surrounding squares
                neighbors_sum = sum(
                    grid[i + di, j + dj]
                    for di in [-1, 0, 1]
                    for dj in [-1, 0, 1]
                    if 0 <= i + di < n and 0 <= j + dj < n
                )
                model.Add(neighbors_sum == puzzle[i][j])

    # Solver
    solver = cp_model.CpSolver()
    status = solver.Solve(model)

    # Solution extraction
    solution = {}
    if status == cp_model.OPTIMAL or status == cp_model.FEASIBLE:
        solution['grid'] = [
            [solver.Value(grid[i, j]) for j in range(n)] for i in range(n)
        ]
    else:
        solution['grid'] = []

    return solution

if __name__ == '__main__':
    result = solve()
    print(json.dumps(result, indent=2))