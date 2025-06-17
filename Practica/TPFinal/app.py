import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt
import math, itertools
from ortools.sat.python import cp_model
import os

st.set_page_config(page_title="Scheduler", layout="wide")

# --- Sidebar: Parámetros y opciones ---
st.sidebar.header("Opciones de visualización y parámetros")
gantt_engine = st.sidebar.selectbox("Motor gráfico para Gantt", ["matplotlib", "plotly"], index=0)

sabores = st.sidebar.multiselect("Sabores", ["neutro", "vainilla", "chocolate"], default=["neutro", "vainilla", "chocolate"])
formats = st.sidebar.multiselect("Formatos", ["200cc", "1000cc"], default=["200cc", "1000cc"])

tanques = st.sidebar.text_input("Tanques (separados por coma)", "1,2")
tanques = [int(x.strip()) for x in tanques.split(",") if x.strip()]

lineas_for = {}
for f in formats:
    val = st.sidebar.text_input(f"Líneas para formato {f} (separadas por coma)", "1,2" if f=="200cc" else "3")
    lineas_for[f] = [int(x.strip()) for x in val.split(",") if x.strip()]

cap = {}
for l in sorted(set(sum(lineas_for.values(), []))):
    cap[l] = st.sidebar.number_input(f"Capacidad línea {l} (u/h)", min_value=1, value=17800 if l in [1,2] else 5000)

t_mezcla = st.sidebar.number_input("Tiempo de mezcla (h)", min_value=1, value=2)
H = st.sidebar.number_input("Horizonte (h)", min_value=1, value=300)

# --- Main view ---
st.markdown("<h1 style='text-align: center;'>Scheduler de Producción</h1>", unsafe_allow_html=True)
st.write("")
st.write("")
st.write("")
# Mostrar imagen y carga de demanda en columnas
col1, col2 = st.columns([1,2])
with col1:
    logo_path = os.path.join(os.path.dirname(__file__), "header.png")
    if os.path.exists(logo_path):
        st.image(logo_path, use_container_width=False, width=320)
    else:
        st.info("Puedes agregar un archivo 'header.png' en la carpeta del proyecto para mostrarlo aquí.")
with col2:
    #st.header("Demanda")
    file = st.file_uploader("Subí un archivo de demanda (Excel o CSV) con las cantidades de producción requeridas", type=["xlsx", "csv"])
    demanda = {}
    if file:
        if file.name.endswith(".xlsx"):
            df = pd.read_excel(file)
        else:
            df = pd.read_csv(file)
        reqs = df.groupby(["SABOR", "FORMATO (CC)"]).agg({"UNIDADES": "sum"})
        demanda_df = reqs.reset_index()
        combinations = []
        quantities = []
        for index, row in demanda_df.iterrows():
            flavour = row["SABOR"].lower()
            format_ = f'{row["FORMATO (CC)"]}cc'
            qtty = row["UNIDADES"]
            combinations.append((flavour, format_))
            quantities.append(qtty)
        demanda = dict(zip(combinations, quantities))
        st.dataframe(demanda_df)
    else:
        st.info("Sube un archivo para cargar la demanda.")

# --- Ejecutar modelo ---
if st.button("Ejecutar Scheduler") and demanda:
    req = demanda
    ord_idx = {s: i for i, s in enumerate(sabores)}  # Orden de prioridad de sabores
    mdl = cp_model.CpModel()  # Crear modelo CP-SAT de ortools

    # Diccionarios para guardar intervalos de mezcla y envasado por recurso
    mez_por_tanque = {t: [] for t in tanques}
    env_por_linea  = {l: [] for l in cap}
    tareas_plot    = {}

    # --- Creacion de variables y restricciones por cada combinación de sabor y formato ---
    for s in sabores:
        for f in formats:
            if (s, f) not in req:
                continue
            units = req[(s, f)]
            dur_env = math.ceil(units / cap[lineas_for[f][0]])  # Duración de envasado

            # =========================================================
            # Creamos las variables de decisión para mezcla y envasado
            # =========================================================

            # --- Opciones de mezcla: una por cada tanque ---
            m_opts = []
            for t in tanques:
                use = mdl.NewBoolVar(f"m_use_{s}_{f}_{t}")  # ¿Se usa este tanque para esta mezcla?
                stv  = mdl.NewIntVar(0, H, f"m_ini_{s}_{f}_{t}")  # Inicio de mezcla
                iv  = mdl.NewOptionalIntervalVar(stv, t_mezcla, stv + t_mezcla, use, f"m_iv_{s}_{f}_{t}")  # Intervalo opcional si es que se realiza mezcla para tanque t y (f,s)
                
                # Agregamos la variable intervalo a la lista de mezclas por tanque
                mez_por_tanque[t].append(iv) 

                # Agregamos la opción de mezcla a las opciones
                m_opts.append((use, stv, t))
            
            # Aseguramos que se use exactamente un tanque para cada mezcla (u es la boolean var que creamos antes)
            mdl.AddExactlyOne(u for u,_,_ in m_opts)

            # --- Opciones de envasado: una por cada línea compatible ---
            e_opts = []
            for l in lineas_for[f]:
                use = mdl.NewBoolVar(f"e_use_{s}_{f}_{l}")  # Boolean que define si ¿Se usa esta línea para este envasado?
                stv  = mdl.NewIntVar(0, H, f"e_ini_{s}_{f}_{l}")  # Inicio de envasado en caso de que suceda
                iv  = mdl.NewOptionalIntervalVar(stv, dur_env, stv + dur_env, use, f"e_iv_{s}_{f}_{l}")  # Largo del intervalo de envasado en caso que funcione
                
                # Agregamos el intervalo a la lista de envasados por línea
                env_por_linea[l].append(iv)
                
                # Agregamos las opciones de envasado
                e_opts.append((use, stv, l, dur_env))

            # Aseguramos que se use exactamente una línea para cada envasado (u es la boolean var que creamos antes)            
            mdl.AddExactlyOne(u for u,_,_,_ in e_opts)

            # ===============================================
            # Creamos restricciones de precedencia inmediata
            # ===============================================

            # --- Restricción: el envasado debe empezar JUSTO después de la mezcla ---
            for m_use, m_st, _ in m_opts: # m_use es la bool que indica si sucede y m_st es el inicio de la mezcla
                for e_use, e_st, _, _ in e_opts: # idem para el envasado
                    mdl.Add(e_st == m_st + t_mezcla).OnlyEnforceIf([m_use, e_use])
            
            # Guardamos para los plots
            tareas_plot[(s,f)] = {"m_opts": m_opts, "e_opts": e_opts, "dur_env": dur_env}


    # ===========================================================
    # Creamos restricciones de no solapamiento y orden de sabores
    # ===========================================================

    # --- Restricción: no solapar mezclas en el mismo tanque ---
    for t in tanques:
        # No se pueden solapar los intervalos
        mdl.AddNoOverlap(mez_por_tanque[t])

    # --- Restricción: no solapar envasados en la misma línea ---
    for l in cap:
        # No se pueden solapar los envasados
        mdl.AddNoOverlap(env_por_linea[l])

    # --- Restricción: secuencia de sabores (orden de prioridad) ---
    
    # generamos todos los pares de sabores y formatos (permutaciones)
    for (s1,f1), (s2,f2) in itertools.permutations(req.keys(), 2):
        if ord_idx.get(s1, -1) < ord_idx.get(s2, -1): # En ord_idx tenemos el orden de los sabores. chequeamos que el sabor 1 pueda ir antes que el sabor 2
            # Para cada tanque, si ambos sabores usan el mismo tanque, forzamos que la mezcla del sabor 2
            # comience después de que termine la mezcla del sabor 1 (según el orden de prioridad de sabores)
            for t in tanques:
                # m1_use: variable booleana que indica si se usa el tanque t para la mezcla de (s1, f1)
                # m1_st: variable entera que representa el inicio de la mezcla de (s1, f1) en el tanque t
                m1_use, m1_st, _ = next(opt for opt in tareas_plot[(s1, f1)]["m_opts"] if opt[2] == t)
                m2_use, m2_st, _ = next(opt for opt in tareas_plot[(s2, f2)]["m_opts"] if opt[2] == t)
                
                # Retriccion de precedencia de sabores
                mdl.Add(m2_st >= m1_st + t_mezcla).OnlyEnforceIf([m1_use, m2_use])

            # Para cada línea de envasado, si ambos sabores usan la misma línea, forzamos que el envasado del sabor 2
            # comience después de que termine el envasado del sabor 1 (según el orden de prioridad de sabores)
            for l in cap:
                if l in lineas_for[f1] and l in lineas_for[f2]:
                    e1_use, e1_st, _, d1 = next(opt for opt in tareas_plot[(s1, f1)]["e_opts"] if opt[2] == l)
                    e2_use, e2_st, _, _  = next(opt for opt in tareas_plot[(s2, f2)]["e_opts"] if opt[2] == l)
                    
                    # Restricción de precedencia de sabores 
                    mdl.Add(e2_st >= e1_st + d1).OnlyEnforceIf([e1_use, e2_use])

    # --- Makespan: minimizar el tiempo total de producción ---
    ends = [iv.EndExpr() for lst in env_por_linea.values() for iv in lst]
    makespan = mdl.NewIntVar(0, H, "makespan")
    mdl.AddMaxEquality(makespan, ends)
    mdl.Minimize(makespan)

    # --- Resolver el modelo ---
    solver = cp_model.CpSolver()
    solver.parameters.max_time_in_seconds = 15
    status = solver.Solve(mdl)

    # --- Mostrar resultados ---
    if status in (cp_model.OPTIMAL, cp_model.FEASIBLE):
        st.success(f"Makespan: {solver.Value(makespan)} h")
        active = []
        for (s,f), data in tareas_plot.items():
            for use, stv, t in data["m_opts"]:
                if solver.Value(use):
                    active.append(("mezcla",s,f,t, solver.Value(stv), t_mezcla))
            for use, stv, l, d in data["e_opts"]:
                if solver.Value(use):
                    active.append(("envasado",s,f,l, solver.Value(stv), d))
        lanes = [f"Tanque {t}" for t in tanques] + [f"Linea {l}" for l in cap]
        colors = {'neutro':'tab:grey','vainilla':'tab:orange','chocolate':'tab:brown'}
        if gantt_engine == "matplotlib":
            fig, ax = plt.subplots(figsize=(14,6))
            for idx, lane in enumerate(lanes):
                for typ,s,f,r,stt,dur in sorted(active, key=lambda x: x[4]):
                    key = f"Tanque {r}" if typ=="mezcla" else f"Linea {r}"
                    if key == lane:
                        ax.broken_barh([(stt,dur)], (idx-.4,.8), facecolors=colors.get(s, 'tab:blue'))
                        short = f"{'Mezcla' if typ=='mezcla' else 'Envasado'}-{s[0].upper()}-{f[:4]}"
                        ax.text(stt + dur/2, idx, short, ha='center', va='center', fontsize=9, color='black')
            ax.set_yticks(range(len(lanes))); ax.set_yticklabels(lanes)
            ax.set_xlabel("Horas")
            ax.set_title("Gantt – Secuencia de Producción de sabores", loc='center')
            ax.grid(True)
            import matplotlib.patches as mpatches
            leg = [mpatches.Patch(color=c, label=s.capitalize()) for s,c in colors.items()]
            ax.legend(handles=leg, loc="upper right", title="Sabores")
            st.pyplot(fig)
        else:
            import plotly.graph_objects as go
            fig = go.Figure()
            lane_map = {lane: idx for idx, lane in enumerate(lanes)}
            color_map = {'neutro':'#888888','vainilla':'#FFA500','chocolate':'#8B4513'}
            for typ,s,f,r,stt,dur in sorted(active, key=lambda x: x[4]):
                key = f"Tanque {r}" if typ=="mezcla" else f"Linea {r}"
                y = lane_map[key]
                color = color_map.get(s, '#1f77b4')
                short = f"{'Mezcla' if typ=='mezcla' else 'Envasado'}-{s[0].upper()}-{f[:4]}"
                fig.add_trace(go.Bar(
                    x=[dur],
                    y=[key],
                    base=[stt],
                    orientation='h',
                    marker=dict(color=color),
                    hovertemplate=f"{short}<br>Inicio: {stt}h<br>Duración: {dur}h<extra></extra>",
                    showlegend=False
                ))
            fig.update_layout(
                barmode='stack',
                height=400+30*len(lanes),
                xaxis_title='Horas',
                yaxis=dict(
                    tickmode='array',
                    tickvals=lanes,
                    ticktext=lanes
                ),
                title="Gantt – producción con secuencia de sabores",
                margin=dict(l=80, r=40, t=60, b=40)
            )
            # Leyenda manual
            for s, c in color_map.items():
                fig.add_trace(go.Bar(x=[None], y=[None], marker=dict(color=c), name=s.capitalize(), showlegend=True))
            st.plotly_chart(fig, use_container_width=True)
    else:
        st.error("El modelo no encontró solución")
else:
    st.info("Carga la demanda y presiona 'Ejecutar Scheduler' para ver el resultado.")

st.caption("Desarrollado con Streamlit y ortools. IO III – 2025")