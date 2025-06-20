from ortools.sat.python import cp_model
import json

def solve():
    # Create the model
    model = cp_model.CpModel()

    # Data from .dzn file
    TotalAircrafts = 10
    EarliestLandingTime = [129, 195, 89, 90, 110, 120, 124, 126, 135, 160]
    TargetLandingTime = [155, 258, 98, 106, 123, 135, 138, 140, 150, 180]
    LatestLandingTime = [689, 653, 517, 501, 634, 603, 657, 592, 510, 604]
    PenaltyTimeAfterTarget = [24, 25, 10, 13, 10, 20, 24, 12, 16, 27]
    PenaltyTimeBeforeTarget = [24, 25, 10, 13, 10, 20, 24, 12, 16, 27]
    SeparationTimeMatrix = [
        [99999, 11, 12, 10, 10, 11, 12, 12, 12, 10],
        [14, 99999, 10, 12, 12, 10, 13, 14, 11, 13],
        [11, 14, 99999, 10, 11, 12, 9, 10, 11, 13],
        [8, 10, 11, 99999, 8, 12, 8, 8, 9, 9],
        [10, 10, 14, 14, 99999, 10, 8, 14, 11, 10],
        [11, 9, 11, 11, 14, 99999, 9, 9, 9, 12],
        [12, 13, 13, 8, 14, 14, 99999, 8, 13, 11],
        [14, 8, 8, 14, 12, 8, 14, 99999, 8, 12],
        [11, 12, 11, 11, 13, 11, 11, 14, 99999, 9],
        [11, 9, 10, 10, 8, 14, 8, 14, 9, 99999]
    ]

    # Decision variables
    LandingTimes = []
    for i in range(TotalAircrafts):
        LandingTimes.append(model.NewIntVar(EarliestLandingTime[i], LatestLandingTime[i], f'LandingTime_{i}'))

    # Penalty calculation refinement
    Penalty = []
    for i in range(TotalAircrafts):
        # Variables for penalties for landing before and after the target time
        before_penalty_var = model.NewIntVar(0, PenaltyTimeBeforeTarget[i] * (TargetLandingTime[i] - EarliestLandingTime[i]), f'BeforePenalty_{i}')
        after_penalty_var = model.NewIntVar(0, PenaltyTimeAfterTarget[i] * (LatestLandingTime[i] - TargetLandingTime[i]), f'AfterPenalty_{i}')
        
        # Constraints to calculate penalties based on landing time
        model.AddMaxEquality(before_penalty_var, [0, PenaltyTimeBeforeTarget[i] * (TargetLandingTime[i] - LandingTimes[i])])
        model.AddMaxEquality(after_penalty_var, [0, PenaltyTimeAfterTarget[i] * (LandingTimes[i] - TargetLandingTime[i])])
        
        # Total penalty for each aircraft
        total_penalty_var = model.NewIntVar(0, PenaltyTimeBeforeTarget[i] * (TargetLandingTime[i] - EarliestLandingTime[i]) + PenaltyTimeAfterTarget[i] * (LatestLandingTime[i] - TargetLandingTime[i]), f'TotalPenalty_{i}')
        model.Add(total_penalty_var == before_penalty_var + after_penalty_var)
        
        Penalty.append(total_penalty_var)

    # Constraints
    # C2: Separation times
    for i in range(TotalAircrafts):
        for j in range(i + 1, TotalAircrafts):
            model.Add(LandingTimes[j] >= LandingTimes[i] + SeparationTimeMatrix[i][j])

    # Objective
    model.Minimize(sum(Penalty))

    # Solve
    solver = cp_model.CpSolver()
    status = solver.Solve(model)

    # Solution dictionary
    solution = {}
    if status == cp_model.OPTIMAL or status == cp_model.FEASIBLE:
        solution['x'] = [solver.Value(LandingTimes[i]) for i in range(TotalAircrafts)]
        solution['penalty'] = [solver.Value(Penalty[i]) for i in range(TotalAircrafts)]
        solution['_objective'] = solver.ObjectiveValue()
    else:
        solution['status'] = 'No solution found.'

    return solution

if __name__ == '__main__':
    result = solve()
    print(json.dumps(result, indent=2))