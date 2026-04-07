# 🏭 ScheduleIt! Factory API — Guía para estudiantes

> **Clase de Investigación Operativa III — Asignación + Scheduling**

---

## ¿Qué es una API?

Pensalo como un **mozo en un restaurante**:

```
Vos (cliente)  →  le pedís algo al mozo  →  el mozo va a la cocina  →  te trae la respuesta
Tu script      →  hace un "request"       →  la API consulta datos   →  te devuelve JSON
```

Una **API** (Application Programming Interface) es simplemente un servidor que espera preguntas y devuelve respuestas en un formato estándar. En nuestro caso, el formato es **JSON**.

---

## ¿Cómo funciona un request?

Cada vez que "consultás" la API, estás haciendo un **HTTP Request**. Tiene tres partes clave:

### 1. El método (qué querés hacer)
En esta API solo usamos `GET` — significa *"dame información"*.

### 2. La URL (a dónde vas)
```
https://scheduleit-api.onrender.com/operarios?page=1&page_size=10
│                    │          └─────────────────┘
│                    │          parámetros opcionales
│                    └── endpoint (qué recurso pedís)
└── host y puerto
```

### 3. El header de autenticación (tu credencial)
```
X-API-Key: IO-2026-SCHEDULEIT
```
Sin esto, el server te rechaza con un error **401 Unauthorized**.

---

## Tu token

El token es el mismo para todos:

```
IO-2026-SCHEDULEIT
```

---

## (Algunos) Endpoints disponibles

| Endpoint | Descripción | Filtros disponibles |
|---|---|---|
| `GET /operarios` | Lista de operarios | `habilidad`, `grupo`, `page`, `page_size` |
| `GET /operarios/{id}` | Un operario por ID | — |
| `GET /lotes/mezcla` | Lotes proceso mezcla | `sabor`, `page`, `page_size` |
| `GET /lotes/envasado` | Lotes proceso envasado | `urgente`, `formato`, `page`, `page_size` |
| `GET /lotes/{id}/entrega` | Fecha de entrega de un lote | — |
| `GET /entregas` | Todas las fechas de entrega | `dia` |
| `GET /procesos` | Lista de procesos especiales | — |
| `GET /procesos/{codigo}` | Un proceso por código | — |

Códigos de proceso: `LIMP`, `CAP`, `FMT_CIR`, `FMT_CUA`

---

## Cómo consumir la API en Python

```python
import requests

BASE_URL = "https://scheduleit-api.onrender.com"
HEADERS = {"X-API-Key": "IO-2026-SCHEDULEIT"}  # ← cambiá según tu grupo

# Ejemplo 1: traer la primera página de operarios
r = requests.get(f"{BASE_URL}/operarios", headers=HEADERS, params={"page": 1, "page_size": 10})
data = r.json()
print(data)
```

---

## Cómo luce una respuesta (JSON)

```json
{
  "page": 1,
  "page_size": 10,
  "total_items": 30,
  "total_pages": 3,
  "data": [
    {
      "id": 1,
      "habilidades": ["M1", "L3", "L4"],
      "grupo": 3
    },
    {
      "id": 2,
      "habilidades": ["M1", "M2", "L2", "L4"],
      "grupo": 1
    }
  ]
}
```

Noten el campo `total_pages`: si es `3`, necesitan hacer **3 requests** para traer todos los datos. Eso es **paginación**.

---

## Códigos de respuesta HTTP más comunes

| Código | Significado | Cuándo aparece |
|--------|------------|----------------|
| `200 OK` | Todo bien ✅ | Request exitoso |
| `401 Unauthorized` | No autenticado ❌ | Falta o es inválido el token |
| `404 Not Found` | No existe ❌ | ID o código inexistente |
| `422 Unprocessable` | Parámetro inválido ❌ | Tipo de dato incorrecto |

---

## Tip: explorar la API sin escribir código

Abrir en el browser:

```
https://scheduleit-api.onrender.com/docs
```

Ahí van a ver la documentación interactiva (Swagger UI) donde pueden probar cada endpoint directamente, ver qué parámetros acepta y cómo luce la respuesta — sin escribir una línea de código.

> **Nota:** La primera vez que acceden puede tardar ~30 segundos en responder porque el servidor se "despierta". Después anda rápido.

---

## Checklist antes de arrancar

- [ ] Tengo mi token del grupo
- [ ] Instalé `requests` (`pip install requests`)

---