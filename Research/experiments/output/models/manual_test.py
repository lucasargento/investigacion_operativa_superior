from ortools.linear_solver import pywraplp

def solve_economic_production_planning_extended():
    # -----------------------------
    # Parámetros del problema
    # -----------------------------
    K = 3  # número de industrias

    # Insumos por unidad producida (matrices KxK)
    InputOne = [
        [0.1, 0.1, 0.2],
        [0.5, 0.1, 0.1],
        [0.5, 0.2, 0.2]
    ]
    ManpowerOne = [0.6, 0.3, 0.2]

    InputTwo = [
        [0.0, 0.1, 0.2],
        [0.7, 0.1, 0.1],
        [0.9, 0.2, 0.2]
    ]
    ManpowerTwo = [0.4, 0.2, 0.1]

    Stock = [150, 80, 100]
    Capacity = [300, 350, 280]

    ManpowerLimit = 470000000.0

    # -----------------------------
    # Crear solver
    # -----------------------------
    solver = pywraplp.Solver.CreateSolver("GLOP")
    if not solver:
        return {"error": "No se pudo crear el solver."}

    # -----------------------------
    # Variables de decisión
    # -----------------------------
    # Producción por año e industria
    Prod = [[solver.NumVar(0, solver.infinity(), f'Prod_{t}_{i}') for i in range(K)] for t in range(3)]
    
    # Capacidad construida en t=0 (solo se construye en t=0)
    CapBuild = [solver.NumVar(0, solver.infinity(), f'CapBuild_{i}') for i in range(K)]

    # Stocks en t=1 y t=2
    Stock1 = [solver.NumVar(0, solver.infinity(), f'Stock1_{i}') for i in range(K)]
    Stock2 = [solver.NumVar(0, solver.infinity(), f'Stock2_{i}') for i in range(K)]

    # -----------------------------
    # Restricciones de recursos por año
    # -----------------------------
    # t=0: Producción + CapBuild + Stock1 <= Stock + Capacity
    for i in range(K):
        solver.Add(Prod[0][i] + CapBuild[i] + Stock1[i] <= Stock[i] + Capacity[i])

    # t=1: Producción + Stock2 <= Capacity + Stock1
    for i in range(K):
        solver.Add(Prod[1][i] + Stock2[i] <= Capacity[i] + Stock1[i])

    # t=2: Producción <= Capacity + CapBuild + Stock2
    for i in range(K):
        solver.Add(Prod[2][i] <= Capacity[i] + CapBuild[i] + Stock2[i])

    # Mano de obra total usada en todos los años
    manpower_total = 0
    for i in range(K):
        manpower_total += ManpowerOne[i] * (Prod[0][i] + CapBuild[i])
        manpower_total += ManpowerTwo[i] * Prod[1][i]
        manpower_total += ManpowerTwo[i] * Prod[2][i]
    solver.Add(manpower_total <= ManpowerLimit)

    # Restricciones de insumos disponibles en cada año
    for j in range(K):  # proveedor
        total_input = 0
        for i in range(K):  # consumidor
            total_input += InputOne[i][j] * (Prod[0][i] + CapBuild[i])
            total_input += InputTwo[i][j] * Prod[1][i]
            total_input += InputTwo[i][j] * Prod[2][i]
        solver.Add(total_input <= Stock[j] + Capacity[j])

    # -----------------------------
    # Función objetivo: maximizar producción en t=1 y t=2
    # -----------------------------
    objective = solver.Sum(Prod[1][i] + Prod[2][i] for i in range(K))
    solver.Maximize(objective)

    # -----------------------------
    # Resolver
    # -----------------------------
    status = solver.Solve()

    if status == pywraplp.Solver.OPTIMAL:
        return {
            "_objective": round(solver.Objective().Value(), 1),
            "Prod1": [round(Prod[0][i].solution_value(), 2) for i in range(K)],
            "Prod2": [round(Prod[1][i].solution_value(), 2) for i in range(K)],
            "Prod3": [round(Prod[2][i].solution_value(), 2) for i in range(K)],
            "CapBuild": [round(CapBuild[i].solution_value(), 2) for i in range(K)],
            "Stock1": [round(Stock1[i].solution_value(), 2) for i in range(K)],
            "Stock2": [round(Stock2[i].solution_value(), 2) for i in range(K)],
        }
    else:
        return {"error": "No se encontró solución óptima."}

# Ejecutar
solution = solve_economic_production_planning_extended()
print(solution)
