"""
Tests de todos los endpoints de ScheduleIt! Factory API.
Imprime las respuestas formateadas con pandas.

Uso:
    1. Levantar el server:  uvicorn server:app --reload --port 8000
    2. Correr los tests:    pytest tests/test_endpoints.py -v -s
"""

import requests
import pandas as pd

BASE_URL = "http://localhost:8000"
HEADERS = {"X-API-Key": "IO-TOKEN-GRP1-2025"}


def sep(title: str):
    print(f"\n{'='*60}")
    print(f"  {title}")
    print(f"{'='*60}")


def test_root():
    sep("GET /  (info general, sin auth)")
    r = requests.get(f"{BASE_URL}/")
    assert r.status_code == 200
    data = r.json()
    print(data)
    assert "api" in data


def test_operarios_paginado():
    sep("GET /operarios  (página 1, 10 por página)")
    r = requests.get(f"{BASE_URL}/operarios", headers=HEADERS, params={"page": 1, "page_size": 10})
    assert r.status_code == 200
    data = r.json()
    print(f"Página {data['page']}/{data['total_pages']}  —  Total: {data['total_items']}")
    df = pd.DataFrame(data["data"])
    print(df.to_string(index=False))
    assert data["total_items"] == 30
    assert len(data["data"]) == 10


def test_operarios_filtro_habilidad():
    sep("GET /operarios?habilidad=A  (filtro por habilidad)")
    r = requests.get(f"{BASE_URL}/operarios", headers=HEADERS, params={"habilidad": "A", "page_size": 30})
    assert r.status_code == 200
    data = r.json()
    df = pd.DataFrame(data["data"])
    print(f"Operarios con habilidad 'A': {data['total_items']}")
    print(df.to_string(index=False))
    assert all("A" in op["habilidades"] for op in data["data"])


def test_operario_por_id():
    sep("GET /operarios/5  (operario específico)")
    r = requests.get(f"{BASE_URL}/operarios/5", headers=HEADERS)
    assert r.status_code == 200
    data = r.json()
    print(data)
    assert data["id"] == 5


def test_lotes_mezcla():
    sep("GET /lotes/mezcla  (todos, page_size=22)")
    r = requests.get(f"{BASE_URL}/lotes/mezcla", headers=HEADERS, params={"page_size": 22})
    assert r.status_code == 200
    data = r.json()
    df = pd.DataFrame(data["data"])
    print(f"Total lotes mezcla: {data['total_items']}")
    print(df.to_string(index=False))
    assert data["total_items"] == 22


def test_lotes_envasado():
    sep("GET /lotes/envasado  (todos, page_size=22)")
    r = requests.get(f"{BASE_URL}/lotes/envasado", headers=HEADERS, params={"page_size": 22})
    assert r.status_code == 200
    data = r.json()
    df = pd.DataFrame(data["data"])
    print(f"Total lotes envasado: {data['total_items']}")
    print(df.to_string(index=False))
    assert data["total_items"] == 22


def test_lotes_envasado_urgentes():
    sep("GET /lotes/envasado?urgente=true")
    r = requests.get(f"{BASE_URL}/lotes/envasado", headers=HEADERS, params={"urgente": True, "page_size": 22})
    assert r.status_code == 200
    data = r.json()
    df = pd.DataFrame(data["data"])
    print(f"Lotes urgentes: {data['total_items']}")
    print(df.to_string(index=False))
    assert all(l["urgente"] for l in data["data"])


def test_fecha_entrega_lote():
    sep("GET /lotes/101/entrega")
    r = requests.get(f"{BASE_URL}/lotes/101/entrega", headers=HEADERS)
    assert r.status_code == 200
    data = r.json()
    print(data)
    assert data["lote"] == "#101"
    assert "dia_entrega" in data


def test_todas_entregas():
    sep("GET /entregas  (todas)")
    r = requests.get(f"{BASE_URL}/entregas", headers=HEADERS)
    assert r.status_code == 200
    data = r.json()
    df = pd.DataFrame(data["entregas"])
    print(f"Total entregas: {data['total']}")
    print(df.to_string(index=False))
    assert data["total"] == 22


def test_entregas_filtro_dia():
    sep("GET /entregas?dia=lunes")
    r = requests.get(f"{BASE_URL}/entregas", headers=HEADERS, params={"dia": "lunes"})
    assert r.status_code == 200
    data = r.json()
    df = pd.DataFrame(data["entregas"])
    print(f"Entregas del lunes: {data['total']}")
    print(df.to_string(index=False))
    assert all(e["dia_entrega"] == "lunes" for e in data["entregas"])


def test_procesos():
    sep("GET /procesos")
    r = requests.get(f"{BASE_URL}/procesos", headers=HEADERS)
    assert r.status_code == 200
    data = r.json()
    df = pd.DataFrame(data["procesos"])
    print(df.to_string(index=False))
    assert len(data["procesos"]) == 4


def test_proceso_por_codigo():
    sep("GET /procesos/LIMP")
    r = requests.get(f"{BASE_URL}/procesos/LIMP", headers=HEADERS)
    assert r.status_code == 200
    data = r.json()
    print(data)
    assert data["codigo"] == "LIMP"


def test_error_token_invalido():
    sep("GET /operarios  (token inválido → 401)")
    r = requests.get(f"{BASE_URL}/operarios", headers={"X-API-Key": "TOKEN-MALO"})
    print(f"Status: {r.status_code}  —  {r.json()}")
    assert r.status_code == 401


def test_error_operario_no_existe():
    sep("GET /operarios/999  (no existe → 404)")
    r = requests.get(f"{BASE_URL}/operarios/999", headers=HEADERS)
    print(f"Status: {r.status_code}  —  {r.json()}")
    assert r.status_code == 404
