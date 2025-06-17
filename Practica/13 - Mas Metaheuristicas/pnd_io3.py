import pandas as pd
import numpy as np
import random
import matplotlib.pyplot as plt
import math


class PND:
    def __init__(self, dataset_a, dataset_b, pos_init):
        self.dataset_a = dataset_a  # Puntos del dataset A
        self.dataset_b = dataset_b  # Puntos del dataset B
        self.pos_init = pos_init    # Posición inicial
        self.n_a = len(dataset_a)   # Número de puntos en A
        self.n_b = len(dataset_b)   # Número de puntos en B
        self.n = self.n_a + self.n_b  # Total de puntos

    # Calcula la distancia euclidiana entre dos puntos
    def distancia(self, p1, p2):
        return math.sqrt((p2[0] - p1[0])**2 + (p2[1] - p1[1])**2)

    # Calcula el costo total de una ruta (TSP)
    def costo(self, ruta_a, ruta_b):
        dist_total = 0
        # Desde el punto inicial al primer punto de A
        if ruta_a:
            dist_total += self.distancia(self.pos_init, self.dataset_a[ruta_a[0]])
        # Entre los puntos consecutivos de A
        for i in range(len(ruta_a) - 1):
            punto_actual = self.dataset_a[ruta_a[i]]
            punto_siguiente = self.dataset_a[ruta_a[i + 1]]
            dist_total += self.distancia(punto_actual, punto_siguiente)
        # Desde el último punto de A al primer punto de B
        if ruta_a and ruta_b:
            dist_total += self.distancia(self.dataset_a[ruta_a[-1]], self.dataset_b[ruta_b[0]])
        # Entre los puntos consecutivos de B
        for i in range(len(ruta_b) - 1):
            punto_actual = self.dataset_b[ruta_b[i]]
            punto_siguiente = self.dataset_b[ruta_b[i + 1]]
            dist_total += self.distancia(punto_actual, punto_siguiente)
        # Desde el último punto de B al punto inicial
        if ruta_b:
            dist_total += self.distancia(self.dataset_b[ruta_b[-1]], self.pos_init)
        elif ruta_a:  # Si no hay puntos en B, regresar desde el último de A
            dist_total += self.distancia(self.dataset_a[ruta_a[-1]], self.pos_init)
        return dist_total

    # Algoritmo greedy para construir una ruta inicial
    def greedy(self):
        # Sub-recorrido para A
        ruta_a = []
        puntos_disponibles_a = list(range(self.n_a))
        costo_total = 0
        pos_actual = self.pos_init

        while puntos_disponibles_a:
            mejor_costo = float('inf')
            mejor_candidato = None
            for idx in puntos_disponibles_a:
                point = self.dataset_a[idx]
                dist = self.distancia(pos_actual, point)
                if dist < mejor_costo:
                    mejor_costo = dist
                    mejor_candidato = idx
            if mejor_candidato is None:
                break
            ruta_a.append(mejor_candidato)
            puntos_disponibles_a.remove(mejor_candidato)
            costo_total += mejor_costo
            pos_actual = self.dataset_a[mejor_candidato]

        # Sub-recorrido para B
        ruta_b = []
        puntos_disponibles_b = list(range(self.n_b))
        if ruta_a:  # Si hay puntos en A, conectar con B
            pos_actual = self.dataset_a[ruta_a[-1]]
        while puntos_disponibles_b:
            mejor_costo = float('inf')
            mejor_candidato = None
            for idx in puntos_disponibles_b:
                point = self.dataset_b[idx]
                dist = self.distancia(pos_actual, point)
                if dist < mejor_costo:
                    mejor_costo = dist
                    mejor_candidato = idx
            if mejor_candidato is None:
                break
            ruta_b.append(mejor_candidato)
            puntos_disponibles_b.remove(mejor_candidato)
            costo_total += mejor_costo
            pos_actual = self.dataset_b[mejor_candidato]

        # Regreso al punto inicial
        if ruta_b:
            costo_total += self.distancia(pos_actual, self.pos_init)
        elif ruta_a:
            costo_total += self.distancia(self.dataset_a[ruta_a[-1]], self.pos_init)

        return ruta_a, ruta_b, costo_total

    def vecino(self, ruta_a, ruta_b):
        # Elegir si modificar ruta_a o ruta_b
        tipo_ruta = random.choice(['A', 'B']) if ruta_a and ruta_b else ('A' if ruta_a else 'B')
        nueva_ruta_a = ruta_a[:]
        nueva_ruta_b = ruta_b[:]
        
        if tipo_ruta == 'A' and len(nueva_ruta_a) > 1:
            # Realizar un movimiento 2-opt (inversión de segmento)
            i, j = sorted(random.sample(range(len(nueva_ruta_a)), 2))
            nueva_ruta_a[i:j + 1] = nueva_ruta_a[i:j + 1][::-1]
            movimiento = ('A', i, j)
        elif tipo_ruta == 'B' and len(nueva_ruta_b) > 1:
            i, j = sorted(random.sample(range(len(nueva_ruta_b)), 2))
            nueva_ruta_b[i:j + 1] = nueva_ruta_b[i:j + 1][::-1]
            movimiento = ('B', i, j)
        else:
            movimiento = None

        return nueva_ruta_a, nueva_ruta_b, movimiento

    def tabu(self, ruta_a, ruta_b, max_iter=1000, tabu_movi=10):
        # Inicializar con las rutas actuales
        mejor_ruta_a = ruta_a[:]
        mejor_ruta_b = ruta_b[:]
        mejor_costo = self.costo(mejor_ruta_a, mejor_ruta_b)
        ruta_actual_a = ruta_a[:]
        ruta_actual_b = ruta_b[:]
        costo_actual = mejor_costo
        tabu_list = []
        iteraciones = 0

        while iteraciones < max_iter:
            # Generar vecinos y encontrar el mejor no tabu
            mejor_vecino_costo = float('inf')
            mejor_vecino_a = ruta_actual_a[:]
            mejor_vecino_b = ruta_actual_b[:]
            mejor_movimiento = None

            # Generar múltiples vecinos para explorar
            for _ in range(max(len(ruta_actual_a), len(ruta_actual_b), 10)):
                nueva_ruta_a, nueva_ruta_b, movimiento = self.vecino(ruta_actual_a, ruta_actual_b)
                if movimiento is None:
                    continue
                costo_vecino = self.costo(nueva_ruta_a, nueva_ruta_b)
                
                # Verificar si el movimiento es tabu o cumple con el criterio de aspiración
                if movimiento not in tabu_list or costo_vecino < mejor_costo:
                    if costo_vecino < mejor_vecino_costo:
                        mejor_vecino_costo = costo_vecino
                        mejor_vecino_a = nueva_ruta_a[:]
                        mejor_vecino_b = nueva_ruta_b[:]
                        mejor_movimiento = movimiento

            # Si se encontró un vecino válido, actualizar la solución actual
            if mejor_movimiento is not None:
                ruta_actual_a = mejor_vecino_a[:]
                ruta_actual_b = mejor_vecino_b[:]
                costo_actual = mejor_vecino_costo

                # Actualizar la mejor solución si es necesario
                if costo_actual < mejor_costo:
                    mejor_ruta_a = ruta_actual_a[:]
                    mejor_ruta_b = ruta_actual_b[:]
                    mejor_costo = costo_actual

                # Añadir el movimiento a la lista tabu
                tabu_list.append(mejor_movimiento)
                # Mantener la lista tabu dentro del tamaño especificado
                if len(tabu_list) > tabu_movi:
                    tabu_list.pop(0)

            iteraciones += 1

        return mejor_ruta_a, mejor_ruta_b, mejor_costo

    def visualizar(self, ruta_a, ruta_b, titulo="Gráfico"):
        plt.figure(figsize=(8, 8))
        # Puntos de A (cuadrados azules)
        plt.scatter([p[0] for p in self.dataset_a], [p[1] for p in self.dataset_a], c='blue', label='Entrega (A)', marker='s', s=100)
        # Puntos de B (círculos rojos)
        plt.scatter([p[0] for p in self.dataset_b], [p[1] for p in self.dataset_b], c='red', label='Entrega (B)', marker='o', s=100)
        # Punto inicial
        plt.plot(self.pos_init[0], self.pos_init[1], 'g*', markersize=20, label='Inicio (20, 30)')

        # Dibujar la ruta
        pos_actual = self.pos_init
        # Ruta de A
        if ruta_a:
            for idx in ruta_a:
                next_pos = self.dataset_a[idx]
                plt.plot([pos_actual[0], next_pos[0]], [pos_actual[1], next_pos[1]], 'k-')
                pos_actual = next_pos
        # Conexión de A a B
        if ruta_a and ruta_b:
            plt.plot([pos_actual[0], self.dataset_b[ruta_b[0]][0]], [pos_actual[1], self.dataset_b[ruta_b[0]][1]], 'k--')
            pos_actual = self.dataset_b[ruta_b[0]]
        # Ruta de B
        for idx in ruta_b:
            next_pos = self.dataset_b[idx]
            plt.plot([pos_actual[0], next_pos[0]], [pos_actual[1], next_pos[1]], 'k-')
            pos_actual = next_pos
        # Regreso al punto inicial
        if ruta_b or ruta_a:
            plt.plot([pos_actual[0], self.pos_init[0]], [pos_actual[1], self.pos_init[1]], 'k-')

        plt.title(titulo)
        plt.xlabel("X (km)")
        plt.ylabel("Y (km)")
        plt.legend()
        plt.grid(True)
        plt.axis([0, 100, 0, 100])
        plt.show()

