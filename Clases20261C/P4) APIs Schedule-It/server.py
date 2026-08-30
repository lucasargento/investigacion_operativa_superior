"""
ScheduleIt! Data API
====================
API educativa para clase de Investigación Operativa.
Versión simplificada: SIN autenticación, abierta a internet.
Expone tres endpoints que devuelven los archivos CSV de la clase en formato JSON.

Correr con:
    uvicorn server:app --host 0.0.0.0 --port 8000
"""

import csv
from pathlib import Path

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware

# ── Configuración ─────────────────────────────────────────────────────────────
BASE_DIR = Path(__file__).parent

DATASETS = {
    "productos": {"path": BASE_DIR / "data" / "productos.csv", "delimiter": ";"},
    "capacidad": {"path": BASE_DIR / "data" / "capacidad.csv", "delimiter": ";"},
    "skus": {"path": BASE_DIR / "data" / "dataset_skus.csv", "delimiter": ","},
}

app = FastAPI(
    title="ScheduleIt! Data API",
    description="API abierta que devuelve los datasets de la clase en JSON.",
    version="2.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


# ── Helpers ───────────────────────────────────────────────────────────────────

def csv_to_json(name: str) -> dict:
    """Lee un CSV y lo devuelve como lista de registros (una fila = un dict)."""
    ds = DATASETS[name]
    path = ds["path"]
    if not path.exists():
        raise HTTPException(status_code=404, detail=f"Archivo no encontrado: {path.name}")
    with path.open(newline="", encoding="utf-8-sig") as f:
        rows = list(csv.DictReader(f, delimiter=ds["delimiter"]))
    return {"archivo": path.name, "total": len(rows), "data": rows}


# ── Endpoints ─────────────────────────────────────────────────────────────────

@app.get("/", tags=["Info"])
def root():
    return {
        "api": "ScheduleIt! Data API",
        "version": "2.0.0",
        "mensaje": "API abierta, sin autenticación.",
        "endpoints": ["/productos", "/capacidad", "/skus"],
        "docs": "/docs",
    }


@app.get("/productos", tags=["Datos"])
def get_productos():
    """Devuelve productos.csv en formato JSON (ganancia, hs por SKU)."""
    return csv_to_json("productos")


@app.get("/capacidad", tags=["Datos"])
def get_capacidad():
    """Devuelve capacidad.csv en formato JSON (capacidades de máquina y MOD)."""
    return csv_to_json("capacidad")


@app.get("/skus", tags=["Datos"])
def get_skus():
    """Devuelve dataset_skus.csv en formato JSON."""
    return csv_to_json("skus")
