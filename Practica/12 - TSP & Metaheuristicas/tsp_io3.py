import pandas as pd
import numpy as np
import random
import matplotlib.pyplot as plt
import math


class TSP:
    def __init__(self, dataset, pos_init):
        self.dataset = dataset  # Lista de puntos
        self.pos_init = pos_init  # Posición inicial
        self.n = len(dataset)  # Número de puntos en el dataset

    # Calcula la distancia euclidiana entre dos puntos
    def distancia(self, p1, p2):
        return math.sqrt((p2[0] - p1[0])**2 + (p2[1] - p1[1])**2)

    # Calcula el costo total de una ruta (TSP)
    def costo(self, ruta):
        dist_total = 0
        # Desde el punto inicial al primer punto de la ruta
        if ruta:
            dist_total += self.distancia(self.pos_init, self.dataset[ruta[0]])
        # Entre los puntos consecutivos de la ruta
        for i in range(len(ruta)-1):
            punto_actual = self.dataset[ruta[i]]
            punto_siguiente = self.dataset[ruta[i+1]]
            # Suma la distancia entre puntos consecutivos
            dist_total += self.distancia(punto_actual, punto_siguiente)
        # Desde el último punto de la ruta al punto inicial
        if ruta:
            dist_total += self.distancia(self.dataset[ruta[-1]], self.pos_init)
        return dist_total

    # Algoritmo greedy para construir una ruta inicial
    def greedy(self):
        n = len(self.dataset)
        ruta = []
        puntos_disponibles = list(range(n))
        costo_total = 0
        pos_actual = self.pos_init

        while puntos_disponibles:
            mejor_costo = float('inf')
            mejor_candidato = None
            for idx in puntos_disponibles:
                point = self.dataset[idx]
                # Calcula la distancia desde la posición actual al punto candidato
                dist = self.distancia(pos_actual, point)
                if dist < mejor_costo:
                    mejor_costo = dist
                    mejor_candidato = idx
            if mejor_candidato is None:
                break
            ruta.append(mejor_candidato)
            puntos_disponibles.remove(mejor_candidato)
            costo_total += mejor_costo
            pos_actual = self.dataset[mejor_candidato]

        # Regreso al punto inicial
        if ruta:
            costo_total += self.distancia(pos_actual, self.pos_init)

        return ruta, costo_total    

    def vecino(self, ruta_actual):
        nueva_ruta = ruta_actual[:] 
        
        tipo_movimiento = random.choice(['intercambio', 'insercion', 'inversion'])

        if tipo_movimiento == 'intercambio' and len(self.dataset) > 1:
            i, j = random.sample(range(len(self.dataset)), 2)
            nueva_ruta[i], nueva_ruta[j] = nueva_ruta[j], nueva_ruta[i]

        elif tipo_movimiento == 'insercion' and len(self.dataset) > 1:
            i = random.randint(0, len(self.dataset)-1)
            j = random.randint(0, len(self.dataset)-1)
            if i != j:
                point = nueva_ruta.pop(i)
                nueva_ruta.insert(j, point)

        elif tipo_movimiento == 'inversion' and len(self.dataset) > 2:
            i, j = sorted(random.sample(range(len(self.dataset)), 2))
            # Invierte el segmento de la ruta entre los índices i y j
            nueva_ruta[i:j+1] = nueva_ruta[i:j+1][::-1]

        return nueva_ruta


    def visualizar(self, ruta, titulo="Gráfico"):
        # Visualización inicial
        plt.figure(figsize=(8, 8))
        plt.scatter([p[0] for p in self.dataset], [p[1] for p in self.dataset], c='red', label='Entrega (B)', marker='s', s=100)
        plt.plot(self.pos_init[0], self.pos_init[1], 'g*', markersize=20, label='Inicio (20, 30)')

        # Dibujar la ruta (ciclo completo)
        if ruta:
            pos_actual = self.pos_init
            for idx in ruta:
                next_pos = self.dataset[idx]
                plt.plot([pos_actual[0], next_pos[0]], [pos_actual[1], next_pos[1]], 'k-')
                pos_actual = next_pos
            # Regreso al punto inicial
            plt.plot([pos_actual[0], self.pos_init[0]], [pos_actual[1], self.pos_init[1]], 'k-')

        plt.title(titulo)
        plt.xlabel("X (km)")
        plt.ylabel("Y (km)")
        plt.legend()
        plt.grid(True)
        plt.axis([0, 100, 0, 100])
        plt.show()





