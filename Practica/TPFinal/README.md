# Optimizador de Producción

Esta aplicación web permite optimizar la programación de producción de helados utilizando un modelo de programación por restricciones.

## Características

- Carga de archivos Excel con datos de demanda
- Configuración flexible de parámetros de producción
- Visualización de resultados mediante diagrama de Gantt
- Optimización automática de la secuencia de producción
- Interfaz moderna y responsiva

## Requisitos

- Python 3.8+
- Node.js 14+
- npm o yarn

## Instalación

1. Clonar el repositorio:
```bash
git clone <repository-url>
cd <repository-name>
```

2. Instalar dependencias del backend:
```bash
pip install -r requirements.txt
```

3. Instalar dependencias del frontend:
```bash
cd frontend
npm install
```

## Ejecución

1. Iniciar el backend:
```bash
python app.py
```

2. En otra terminal, iniciar el frontend:
```bash
cd frontend
npm start
```

3. Abrir el navegador en http://localhost:3000

## Uso

1. Cargar un archivo Excel con los datos de demanda
2. Configurar los parámetros de producción:
   - Fecha de inicio
   - Tiempo de mezcla
   - Horizonte de planificación
3. Hacer clic en "Optimizar" para generar el plan de producción
4. Visualizar los resultados en el diagrama de Gantt

## Formato del archivo Excel

El archivo Excel debe contener las siguientes columnas:
- SABOR: Nombre del sabor (neutro, vanilla, chocolate)
- FORMATO (CC): Capacidad en centímetros cúbicos (200, 1000)
- UNIDADES: Cantidad de unidades a producir 