"""
ScheduleIt! Factory API
========================
API educativa para clase de Investigación Operativa - Asignación + Scheduling
Requiere token de autenticación. Ver README al final del archivo.
"""

from fastapi import FastAPI, Depends, HTTPException, Header, Query
from fastapi.middleware.cors import CORSMiddleware
from typing import Optional
import time
import math

app = FastAPI(
    title="ScheduleIt! Factory API",
    description="API de datos para problema de Asignación + Scheduling (IO 2025)",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# ── Auth ──────────────────────────────────────────────────────────────────────

VALID_TOKENS = {
    "grupo-1": "IO-TOKEN-GRP1-2025",
    "grupo-2": "IO-TOKEN-GRP2-2025",
    "grupo-3": "IO-TOKEN-GRP3-2025",
}

def verify_token(x_api_key: str = Header(..., description="API key del grupo")):
    if x_api_key not in VALID_TOKENS.values():
        raise HTTPException(status_code=401, detail="Token inválido. Revisá tu X-API-Key.")
    # Simulated slight delay (realistic feel)
    time.sleep(0.05)
    return x_api_key


# ── Static Data ────────────────────────────────────────────────────────────────

OPERARIOS = [
    {"id": 1,  "habilidades": ["M1", "L3", "L4"],             "grupo": 3},
    {"id": 2,  "habilidades": ["M1", "M2", "L2", "L4"],       "grupo": 1},
    {"id": 3,  "habilidades": ["M1"],                          "grupo": 3},
    {"id": 4,  "habilidades": ["A", "L1", "L3"],               "grupo": 1},
    {"id": 5,  "habilidades": ["M1", "L4"],                    "grupo": 2},
    {"id": 6,  "habilidades": ["M3", "L1", "L2"],              "grupo": 3},
    {"id": 7,  "habilidades": ["M2", "L4"],                    "grupo": 2},
    {"id": 8,  "habilidades": ["M3", "L3"],                    "grupo": 2},
    {"id": 9,  "habilidades": ["L3", "L4"],                    "grupo": 1},
    {"id": 10, "habilidades": ["M1", "L1"],                    "grupo": 1},
    {"id": 11, "habilidades": ["L1"],                          "grupo": 1},
    {"id": 12, "habilidades": ["A", "M2", "L1"],               "grupo": 3},
    {"id": 13, "habilidades": ["L2", "L3"],                    "grupo": 3},
    {"id": 14, "habilidades": ["M3", "L1", "L4"],              "grupo": 2},
    {"id": 15, "habilidades": ["A", "M2", "L2"],               "grupo": 1},
    {"id": 16, "habilidades": ["M1","M2","L1","L2","L3","L4"], "grupo": 2},
    {"id": 17, "habilidades": ["A", "M2", "L2", "L4"],        "grupo": 2},
    {"id": 18, "habilidades": ["M2", "L2", "L3", "L4"],       "grupo": 2},
    {"id": 19, "habilidades": ["M3", "L1", "L3"],              "grupo": 3},
    {"id": 20, "habilidades": ["M2"],                          "grupo": 2},
    {"id": 21, "habilidades": ["M2", "M3", "L3"],              "grupo": 1},
    {"id": 22, "habilidades": ["M1", "L3", "L4"],              "grupo": 3},
    {"id": 23, "habilidades": ["L1", "L4"],                    "grupo": 3},
    {"id": 24, "habilidades": ["A", "M2", "M3", "L4"],        "grupo": 3},
    {"id": 25, "habilidades": ["L2"],                          "grupo": 3},
    {"id": 26, "habilidades": ["A", "M3", "L2", "L3"],        "grupo": 1},
    {"id": 27, "habilidades": ["A", "M1"],                     "grupo": 1},
    {"id": 28, "habilidades": ["A"],                           "grupo": 2},
    {"id": 29, "habilidades": ["A", "L3"],                     "grupo": 1},
    {"id": 30, "habilidades": ["M1", "L3"],                    "grupo": 2},
]

LOTES_MEZCLA = [
    {"lote": "#101", "hs": 4, "sabor": 3, "formato": "triangulo"},
    {"lote": "#102", "hs": 4, "sabor": 2, "formato": "triangulo"},
    {"lote": "#103", "hs": 4, "sabor": 1, "formato": "triangulo"},
    {"lote": "#104", "hs": 3, "sabor": 3, "formato": "triangulo"},
    {"lote": "#105", "hs": 4, "sabor": 3, "formato": "triangulo"},
    {"lote": "#106", "hs": 4, "sabor": 2, "formato": "triangulo"},
    {"lote": "#107", "hs": 3, "sabor": 1, "formato": "triangulo"},
    {"lote": "#108", "hs": 3, "sabor": 2, "formato": "triangulo"},
    {"lote": "#109", "hs": 3, "sabor": 3, "formato": "triangulo"},
    {"lote": "#110", "hs": 7, "sabor": 3, "formato": "triangulo"},
    {"lote": "#111", "hs": 4, "sabor": 3, "formato": "triangulo"},
    {"lote": "#112", "hs": 3, "sabor": 2, "formato": "triangulo"},
    {"lote": "#113", "hs": 3, "sabor": 1, "formato": "triangulo"},
    {"lote": "#114", "hs": 2, "sabor": 1, "formato": "triangulo"},
    {"lote": "#115", "hs": 4, "sabor": 1, "formato": "triangulo"},
    {"lote": "#116", "hs": 7, "sabor": 1, "formato": "triangulo"},
    {"lote": "#117", "hs": 4, "sabor": 3, "formato": "triangulo"},
    {"lote": "#118", "hs": 3, "sabor": 3, "formato": "triangulo"},
    {"lote": "#119", "hs": 5, "sabor": 2, "formato": "triangulo"},
    {"lote": "#120", "hs": 4, "sabor": 1, "formato": "triangulo"},
    {"lote": "#121", "hs": 5, "sabor": 1, "formato": "triangulo"},
    {"lote": "#122", "hs": 7, "sabor": 1, "formato": "triangulo"},
]

LOTES_ENVASADO = [
    {"lote": "#101", "hs": 7,  "sabor": 3, "formato": "cuadrado", "urgente": True},
    {"lote": "#102", "hs": 7,  "sabor": 2, "formato": "circulo",  "urgente": False},
    {"lote": "#103", "hs": 6,  "sabor": 1, "formato": "cuadrado", "urgente": True},
    {"lote": "#104", "hs": 5,  "sabor": 3, "formato": "cuadrado", "urgente": False},
    {"lote": "#105", "hs": 6,  "sabor": 3, "formato": "cuadrado", "urgente": False},
    {"lote": "#106", "hs": 6,  "sabor": 2, "formato": "cuadrado", "urgente": False},
    {"lote": "#107", "hs": 5,  "sabor": 1, "formato": "cuadrado", "urgente": False},
    {"lote": "#108", "hs": 5,  "sabor": 2, "formato": "cuadrado", "urgente": False},
    {"lote": "#109", "hs": 5,  "sabor": 3, "formato": "cuadrado", "urgente": True},
    {"lote": "#110", "hs": 13, "sabor": 3, "formato": "circulo",  "urgente": False},
    {"lote": "#111", "hs": 8,  "sabor": 3, "formato": "cuadrado", "urgente": False},
    {"lote": "#112", "hs": 6,  "sabor": 2, "formato": "circulo",  "urgente": False},
    {"lote": "#113", "hs": 5,  "sabor": 1, "formato": "cuadrado", "urgente": False},
    {"lote": "#114", "hs": 3,  "sabor": 1, "formato": "cuadrado", "urgente": False},
    {"lote": "#115", "hs": 7,  "sabor": 1, "formato": "circulo",  "urgente": False},
    {"lote": "#116", "hs": 13, "sabor": 1, "formato": "circulo",  "urgente": False},
    {"lote": "#117", "hs": 7,  "sabor": 3, "formato": "circulo",  "urgente": False},
    {"lote": "#118", "hs": 6,  "sabor": 3, "formato": "circulo",  "urgente": False},
    {"lote": "#119", "hs": 10, "sabor": 2, "formato": "circulo",  "urgente": True},
    {"lote": "#120", "hs": 7,  "sabor": 1, "formato": "circulo",  "urgente": False},
    {"lote": "#121", "hs": 10, "sabor": 1, "formato": "circulo",  "urgente": False},
    {"lote": "#122", "hs": 13, "sabor": 1, "formato": "circulo",  "urgente": False},
]

FECHAS_ENTREGA = {
    "#101": "martes",   "#102": "miercoles", "#103": "lunes",
    "#104": "lunes",    "#105": "miercoles", "#106": "martes",
    "#107": "miercoles","#108": "miercoles", "#109": "lunes",
    "#110": "martes",   "#111": "martes",    "#112": "miercoles",
    "#113": "martes",   "#114": "lunes",     "#115": "martes",
    "#116": "martes",   "#117": "martes",    "#118": "miercoles",
    "#119": "miercoles","#120": "jueves",    "#121": "lunes",
    "#122": "jueves",
}

PROCESOS = [
    {"nombre": "Limpieza",                    "duracion_hs": 6,  "codigo": "LIMP"},
    {"nombre": "Capacitación",                "duracion_hs": 8,  "codigo": "CAP"},
    {"nombre": "Cambio de Formato a Círculo", "duracion_hs": 4,  "codigo": "FMT_CIR"},
    {"nombre": "Cambio de Formato a Cuadrado","duracion_hs": 6,  "codigo": "FMT_CUA"},
]


# ── Helpers ────────────────────────────────────────────────────────────────────

def paginate(data: list, page: int, page_size: int):
    total = len(data)
    total_pages = math.ceil(total / page_size)
    start = (page - 1) * page_size
    end = start + page_size
    return {
        "page": page,
        "page_size": page_size,
        "total_items": total,
        "total_pages": total_pages,
        "data": data[start:end],
    }


# ── Endpoints ──────────────────────────────────────────────────────────────────

@app.get("/", tags=["Info"])
def root():
    return {
        "api": "ScheduleIt! Factory API",
        "version": "1.0.0",
        "mensaje": "Autenticarse con X-API-Key en el header. Ver /docs para la documentación.",
        "docs": "/docs",
    }


@app.get("/operarios", tags=["Operarios"])
def get_operarios(
    page: int = Query(1, ge=1, description="Número de página"),
    page_size: int = Query(10, ge=1, le=30, description="Items por página (máx 30)"),
    habilidad: Optional[str] = Query(None, description="Filtrar por habilidad (ej: M1, L3, A)"),
    grupo: Optional[int] = Query(None, ge=1, le=3, description="Filtrar por grupo (1, 2 o 3)"),
    token: str = Depends(verify_token),
):
    """
    Devuelve el listado de operarios con sus habilidades y grupo.
    Soporta filtrado por habilidad y/o grupo, y paginación.
    """
    data = OPERARIOS
    if habilidad:
        data = [o for o in data if habilidad.upper() in o["habilidades"]]
    if grupo:
        data = [o for o in data if o["grupo"] == grupo]
    return paginate(data, page, page_size)


@app.get("/operarios/{operario_id}", tags=["Operarios"])
def get_operario(operario_id: int, token: str = Depends(verify_token)):
    """Devuelve los datos de un operario específico por su ID."""
    op = next((o for o in OPERARIOS if o["id"] == operario_id), None)
    if not op:
        raise HTTPException(status_code=404, detail=f"Operario {operario_id} no encontrado.")
    return op


@app.get("/lotes/mezcla", tags=["Lotes"])
def get_lotes_mezcla(
    page: int = Query(1, ge=1),
    page_size: int = Query(10, ge=1, le=22),
    sabor: Optional[int] = Query(None, ge=1, le=3, description="Filtrar por sabor (1, 2 o 3)"),
    token: str = Depends(verify_token),
):
    """
    Devuelve los lotes del proceso de Mezcla con su duración en horas y sabor.
    El formato es siempre triángulo en esta etapa.
    """
    data = LOTES_MEZCLA
    if sabor:
        data = [l for l in data if l["sabor"] == sabor]
    return paginate(data, page, page_size)


@app.get("/lotes/envasado", tags=["Lotes"])
def get_lotes_envasado(
    page: int = Query(1, ge=1),
    page_size: int = Query(10, ge=1, le=22),
    urgente: Optional[bool] = Query(None, description="Filtrar solo urgentes"),
    formato: Optional[str] = Query(None, description="Filtrar por formato: circulo | cuadrado"),
    token: str = Depends(verify_token),
):
    """
    Devuelve los lotes del proceso de Envasado.
    Incluye formato de destino (círculo o cuadrado) y flag de urgencia.
    """
    data = LOTES_ENVASADO
    if urgente is not None:
        data = [l for l in data if l["urgente"] == urgente]
    if formato:
        data = [l for l in data if l["formato"] == formato.lower()]
    return paginate(data, page, page_size)


@app.get("/lotes/{lote_id}/entrega", tags=["Lotes"])
def get_fecha_entrega(lote_id: str, token: str = Depends(verify_token)):
    """
    Devuelve la fecha de entrega programada para un lote específico.
    El lote_id debe tener el formato: 101, 102, ... (sin #).
    """
    key = f"#{lote_id}"
    if key not in FECHAS_ENTREGA:
        raise HTTPException(status_code=404, detail=f"Lote {key} no encontrado.")
    return {"lote": key, "dia_entrega": FECHAS_ENTREGA[key]}


@app.get("/entregas", tags=["Lotes"])
def get_todas_entregas(
    dia: Optional[str] = Query(None, description="Filtrar por día: lunes | martes | miercoles | jueves"),
    token: str = Depends(verify_token),
):
    """
    Devuelve todas las fechas de entrega programadas.
    Opcionalmente filtrar por día de la semana.
    """
    result = [{"lote": k, "dia_entrega": v} for k, v in FECHAS_ENTREGA.items()]
    if dia:
        result = [r for r in result if r["dia_entrega"] == dia.lower()]
    return {"total": len(result), "entregas": result}


@app.get("/procesos", tags=["Procesos"])
def get_procesos(token: str = Depends(verify_token)):
    """
    Devuelve los procesos especiales disponibles con su duración en horas.
    Incluye: Limpieza, Capacitación y Cambios de Formato.
    """
    return {"procesos": PROCESOS}


@app.get("/procesos/{codigo}", tags=["Procesos"])
def get_proceso(codigo: str, token: str = Depends(verify_token)):
    """
    Devuelve información de un proceso específico por su código.
    Códigos disponibles: LIMP, CAP, FMT_CIR, FMT_CUA
    """
    proc = next((p for p in PROCESOS if p["codigo"] == codigo.upper()), None)
    if not proc:
        raise HTTPException(
            status_code=404,
            detail=f"Proceso '{codigo}' no encontrado. Códigos válidos: LIMP, CAP, FMT_CIR, FMT_CUA"
        )
    return proc


# ── Run ────────────────────────────────────────────────────────────────────────
# uvicorn factory_api:app --reload --port 8000