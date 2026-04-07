══════════════════════════════════════════════════════════
README PARA ESTUDIANTES
══════════════════════════════════════════════════════════

INSTALACIÓN:
    pip install fastapi uvicorn pandas

EJECUCIÓN:
    uvicorn server:app --reload --port 8000

DOCUMENTACIÓN INTERACTIVA:
    http://localhost:8000/docs

AUTENTICACIÓN:
    Todos los endpoints (excepto GET /) requieren el header:
        X-API-Key: IO-2026-SCHEDULEIT

EJEMPLO CON curl:
    curl -H "X-API-Key: IO-2026-SCHEDULEIT" http://localhost:8000/operarios?page=1&page_size=5

EJEMPLO CON Python (requests):
    import requests
    headers = {"X-API-Key": "IO-2026-SCHEDULEIT"}
    r = requests.get("http://localhost:8000/operarios", headers=headers, params={"page": 1, "page_size": 10})
    print(r.json())

ENDPOINTS DISPONIBLES:
    GET /                               → Info general (sin auth)
    GET /operarios                      → Lista operarios (paginado, filtros: habilidad, grupo)
    GET /operarios/{id}                 → Operario por ID
    GET /lotes/mezcla                   → Lotes de mezcla (paginado, filtro: sabor)
    GET /lotes/envasado                 → Lotes de envasado (paginado, filtros: urgente, formato)
    GET /lotes/{id}/entrega             → Fecha de entrega de un lote (ej: /lotes/101/entrega)
    GET /entregas                       → Todas las fechas de entrega (filtro: dia)
    GET /procesos                       → Lista de procesos especiales
    GET /procesos/{codigo}              → Proceso por código (LIMP, CAP, FMT_CIR, FMT_CUA)

══════════════════════════════════════════════════════════
