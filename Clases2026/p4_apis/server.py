"""
ScheduleIt! Factory API
========================
API educativa para clase de Investigación Operativa - Asignación + Scheduling
Requiere token de autenticación. Ver README al final del archivo.
"""

from fastapi import FastAPI, Depends, HTTPException, Header, Query
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse
from pydantic import BaseModel
from typing import Optional
from datetime import datetime
import hashlib
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

API_TOKEN = "IO-2026-SCHEDULEIT"

def verify_token(x_api_key: str = Header(..., description="API key de la clase")):
    if x_api_key != API_TOKEN:
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


# ── Verificación en clase ─────────────────────────────────────────────────────

CODIGO_SALT = "scheduleit-io3-2026"

# Estado en memoria: {codigo: {nombre, apellido, timestamp}}
verificaciones: dict[str, dict] = {}
# Mapa nombre_key -> codigo (para evitar duplicados)
alumnos_registrados: dict[str, str] = {}


def generar_codigo(nombre: str, apellido: str) -> str:
    raw = f"{nombre.strip().lower()}-{apellido.strip().lower()}-{CODIGO_SALT}"
    return hashlib.sha256(raw.encode()).hexdigest()[:8].upper()


class VerificarRequest(BaseModel):
    nombre: str
    apellido: str


class ValidarRequest(BaseModel):
    codigo: str


@app.post("/verificar", tags=["Verificación"])
def verificar_alumno(req: VerificarRequest, token: str = Depends(verify_token)):
    """
    Enviar nombre y apellido para recibir un código secreto único.
    Ese código se usa después en el tablero para confirmar la conexión.
    """
    nombre = req.nombre.strip()
    apellido = req.apellido.strip()
    if not nombre or not apellido:
        raise HTTPException(status_code=400, detail="Nombre y apellido son requeridos.")
    codigo = generar_codigo(nombre, apellido)
    nombre_key = f"{nombre.lower()}_{apellido.lower()}"
    alumnos_registrados[nombre_key] = codigo
    return {
        "mensaje": f"Hola {nombre}! Tu código secreto es el siguiente. Ingresalo en /tablero para verificar tu conexión.",
        "codigo": codigo,
    }


@app.post("/validar", tags=["Verificación"])
def validar_codigo(req: ValidarRequest):
    """
    Validar un código en el tablero. No requiere autenticación
    (el alumno accede desde el browser).
    """
    codigo = req.codigo.strip().upper()
    # Buscar qué alumno tiene ese código
    alumno = None
    for nombre_key, cod in alumnos_registrados.items():
        if cod == codigo:
            nombre, apellido = nombre_key.split("_", 1)
            alumno = {"nombre": nombre.title(), "apellido": apellido.title()}
            break
    if not alumno:
        raise HTTPException(status_code=404, detail="Código no encontrado. Revisá que lo hayas copiado bien.")
    if codigo in verificaciones:
        return {"mensaje": f"{alumno['nombre']} {alumno['apellido']} ya estaba verificado/a!", "ya_verificado": True}
    verificaciones[codigo] = {
        "nombre": alumno["nombre"],
        "apellido": alumno["apellido"],
        "timestamp": datetime.now().isoformat(),
        "posicion": len(verificaciones) + 1,
    }
    return {
        "mensaje": f"Verificado! {alumno['nombre']} {alumno['apellido']} llegó en el puesto #{len(verificaciones)}",
        "posicion": len(verificaciones),
    }


@app.get("/verificaciones", tags=["Verificación"])
def get_verificaciones():
    """Lista de alumnos verificados ordenados por llegada (para el tablero)."""
    ranking = sorted(verificaciones.values(), key=lambda x: x["posicion"])
    return {"total": len(ranking), "ranking": ranking}


@app.get("/tablero", response_class=HTMLResponse, tags=["Verificación"])
def tablero():
    """Tablero HTML en vivo para que los alumnos ingresen su código y vean el ranking."""
    return """<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>IO Superior — APIs</title>
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { font-family: 'Segoe UI', system-ui, sans-serif; background: #0f172a; color: #e2e8f0; min-height: 100vh; }
  .container { max-width: 600px; margin: 0 auto; padding: 2rem 1rem; }
  h1 { text-align: center; font-size: 1.8rem; margin-bottom: 0.3rem; }
  .subtitle { text-align: center; color: #94a3b8; margin-bottom: 2rem; font-size: 0.95rem; }
  .card { background: #1e293b; border-radius: 12px; padding: 1.5rem; margin-bottom: 1.5rem; }
  .card h2 { font-size: 1.1rem; margin-bottom: 1rem; color: #38bdf8; }
  input { width: 100%; padding: 0.75rem 1rem; border-radius: 8px; border: 1px solid #334155; background: #0f172a; color: #e2e8f0; font-size: 1.1rem; letter-spacing: 2px; text-align: center; text-transform: uppercase; }
  input:focus { outline: none; border-color: #38bdf8; }
  button { width: 100%; margin-top: 0.75rem; padding: 0.75rem; border-radius: 8px; border: none; background: #2563eb; color: white; font-size: 1rem; font-weight: 600; cursor: pointer; transition: background 0.2s; }
  button:hover { background: #1d4ed8; }
  button:disabled { background: #334155; cursor: not-allowed; }
  .msg { margin-top: 0.75rem; padding: 0.75rem; border-radius: 8px; text-align: center; font-weight: 500; }
  .msg.ok { background: #064e3b; color: #6ee7b7; }
  .msg.err { background: #450a0a; color: #fca5a5; }
  .ranking-item { display: flex; align-items: center; padding: 0.6rem 0; border-bottom: 1px solid #334155; }
  .ranking-item:last-child { border-bottom: none; }
  .pos { font-size: 1.3rem; font-weight: 700; width: 2.5rem; text-align: center; color: #facc15; }
  .pos.p1 { color: #fbbf24; font-size: 1.5rem; }
  .pos.p2 { color: #d1d5db; }
  .pos.p3 { color: #b45309; }
  .nombre { flex: 1; font-size: 1rem; }
  .hora { color: #64748b; font-size: 0.85rem; }
  .empty { text-align: center; color: #475569; padding: 2rem 0; font-style: italic; }
  .counter { text-align: center; color: #64748b; font-size: 0.85rem; margin-top: 0.5rem; }
</style>
</head>
<body>
<div class="container">
  <h1>IO Superior</h1>
  <p class="subtitle">APIs — Verificación de Conexión</p>

  <div class="card">
    <h2>Ingresá tu código</h2>
    <input type="text" id="codigo" placeholder="EJ: A1B2C3D4" maxlength="8" />
    <button id="btn" onclick="validar()">Verificar</button>
    <div id="msg"></div>
  </div>

  <div class="card">
    <h2>Ranking de llegada</h2>
    <div id="ranking"><div class="empty">Esperando resultados...</div></div>
    <div class="counter" id="counter"></div>
  </div>
</div>

<script>
  const msgEl = document.getElementById('msg');
  const rankEl = document.getElementById('ranking');
  const counterEl = document.getElementById('counter');
  const btnEl = document.getElementById('btn');
  const inputEl = document.getElementById('codigo');

  inputEl.addEventListener('keydown', e => { if (e.key === 'Enter') validar(); });

  async function validar() {
    const codigo = inputEl.value.trim();
    if (!codigo) return;
    btnEl.disabled = true;
    try {
      const res = await fetch('/validar', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({codigo})
      });
      const data = await res.json();
      if (!res.ok) {
        msgEl.className = 'msg err';
        msgEl.textContent = data.detail;
      } else {
        msgEl.className = 'msg ok';
        msgEl.textContent = data.mensaje;
        inputEl.value = '';
        fetchRanking();
      }
    } catch(e) {
      msgEl.className = 'msg err';
      msgEl.textContent = 'Error de conexión';
    }
    btnEl.disabled = false;
  }

  async function fetchRanking() {
    try {
      const res = await fetch('/verificaciones');
      const data = await res.json();
      if (data.total === 0) {
        rankEl.innerHTML = '<div class="empty">Esperando al primer valiente...</div>';
        counterEl.textContent = '';
        return;
      }
      counterEl.textContent = data.total + ' verificado' + (data.total !== 1 ? 's' : '');
      rankEl.innerHTML = data.ranking.map(v => {
        const cls = v.posicion <= 3 ? ' p' + v.posicion : '';
        const hora = new Date(v.timestamp).toLocaleTimeString('es-AR', {hour:'2-digit', minute:'2-digit', second:'2-digit'});
        return '<div class="ranking-item">' +
          '<div class="pos' + cls + '">' + v.posicion + '</div>' +
          '<div class="nombre">' + v.nombre + ' ' + v.apellido + '</div>' +
          '<div class="hora">' + hora + '</div></div>';
      }).join('');
    } catch(e) {}
  }

  fetchRanking();
  setInterval(fetchRanking, 3000);
</script>
</body>
</html>"""


# ── Resultados de optimización ────────────────────────────────────────────────

# Estado en memoria: {codigo: {nombre, apellido, valor_objetivo, timestamp, posicion}}
resultados: dict[str, dict] = {}


class ResultadoRequest(BaseModel):
    codigo: str
    valor_objetivo: float


@app.post("/resultados", tags=["Resultados"])
def enviar_resultado(req: ResultadoRequest):
    """
    Enviar el resultado del modelo de optimización.
    Requiere el código de verificación y el valor de la función objetivo.
    """
    codigo = req.codigo.strip().upper()
    # Verificar que el código existe
    if codigo not in verificaciones:
        raise HTTPException(
            status_code=400,
            detail="Código no verificado. Primero verificate en /tablero."
        )
    alumno = verificaciones[codigo]
    resultados[codigo] = {
        "nombre": alumno["nombre"],
        "apellido": alumno["apellido"],
        "valor_objetivo": req.valor_objetivo,
        "timestamp": datetime.now().isoformat(),
        "posicion": len(resultados) + 1 if codigo not in resultados else resultados[codigo]["posicion"],
    }
    return {
        "mensaje": f"Resultado registrado! {alumno['nombre']} {alumno['apellido']}: {req.valor_objetivo}h",
        "valor_objetivo": req.valor_objetivo,
    }


@app.get("/resultados", tags=["Resultados"])
def get_resultados():
    """Lista de resultados ordenados por valor objetivo (mayor es mejor)."""
    ranking = sorted(resultados.values(), key=lambda x: x["valor_objetivo"], reverse=True)
    for i, r in enumerate(ranking):
        r["ranking"] = i + 1
    return {"total": len(ranking), "ranking": ranking}


@app.get("/tablero-resultados", response_class=HTMLResponse, tags=["Resultados"])
def tablero_resultados():
    """Tablero HTML en vivo mostrando los resultados de optimización de cada alumno."""
    return """<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>IO Superior — Resultados</title>
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { font-family: 'Segoe UI', system-ui, sans-serif; background: #0f172a; color: #e2e8f0; min-height: 100vh; }
  .container { max-width: 700px; margin: 0 auto; padding: 2rem 1rem; }
  h1 { text-align: center; font-size: 1.8rem; margin-bottom: 0.3rem; }
  .subtitle { text-align: center; color: #94a3b8; margin-bottom: 2rem; font-size: 0.95rem; }
  .card { background: #1e293b; border-radius: 12px; padding: 1.5rem; margin-bottom: 1.5rem; }
  .card h2 { font-size: 1.1rem; margin-bottom: 1rem; color: #38bdf8; }
  .ranking-item { display: flex; align-items: center; padding: 0.75rem 0; border-bottom: 1px solid #334155; }
  .ranking-item:last-child { border-bottom: none; }
  .pos { font-size: 1.4rem; font-weight: 700; width: 2.5rem; text-align: center; }
  .pos.p1 { color: #fbbf24; font-size: 1.6rem; }
  .pos.p2 { color: #d1d5db; }
  .pos.p3 { color: #b45309; }
  .info { flex: 1; }
  .nombre { font-size: 1.05rem; font-weight: 600; }
  .hora { color: #64748b; font-size: 0.8rem; }
  .valor { font-size: 1.3rem; font-weight: 700; color: #4ade80; text-align: right; min-width: 80px; }
  .valor span { font-size: 0.8rem; font-weight: 400; color: #94a3b8; }
  .empty { text-align: center; color: #475569; padding: 2rem 0; font-style: italic; }
  .counter { text-align: center; color: #64748b; font-size: 0.85rem; margin-top: 0.5rem; }
  .best { background: #064e3b22; border-radius: 8px; padding: 0.3rem; }
</style>
</head>
<body>
<div class="container">
  <h1>IO Superior</h1>
  <p class="subtitle">Resultados de Optimización</p>

  <div class="card">
    <h2>Ranking por Valor Objetivo</h2>
    <div id="ranking"><div class="empty">Esperando resultados...</div></div>
    <div class="counter" id="counter"></div>
  </div>
</div>

<script>
  const rankEl = document.getElementById('ranking');
  const counterEl = document.getElementById('counter');

  async function fetchResultados() {
    try {
      const res = await fetch('/resultados');
      const data = await res.json();
      if (data.total === 0) {
        rankEl.innerHTML = '<div class="empty">Esperando resultados...</div>';
        counterEl.textContent = '';
        return;
      }
      counterEl.textContent = data.total + ' resultado' + (data.total !== 1 ? 's' : '');
      rankEl.innerHTML = data.ranking.map((v, idx) => {
        const cls = idx < 3 ? ' p' + (idx + 1) : '';
        const bestCls = idx === 0 ? ' best' : '';
        const hora = new Date(v.timestamp).toLocaleTimeString('es-AR', {hour:'2-digit', minute:'2-digit', second:'2-digit'});
        return '<div class="ranking-item' + bestCls + '">' +
          '<div class="pos' + cls + '">' + (idx + 1) + '</div>' +
          '<div class="info"><div class="nombre">' + v.nombre + ' ' + v.apellido + '</div>' +
          '<div class="hora">' + hora + '</div></div>' +
          '<div class="valor">' + v.valor_objetivo + ' <span>hs</span></div></div>';
      }).join('');
    } catch(e) {}
  }

  fetchResultados();
  setInterval(fetchResultados, 3000);
</script>
</body>
</html>"""


# ── Run ────────────────────────────────────────────────────────────────────────
# uvicorn server:app --reload --port 8000