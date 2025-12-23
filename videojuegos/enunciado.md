# 🎮 Ejercicio de Simulacro: "Gestión de Videojuegos"
El Enunciado: Se desea gestionar una tienda digital. Crea la clase Videojuego con:

## Atributos:

- titulo (String)

- genero (Símbolo: :rpg, :shooter, :indie)

- precio (Float)

- ventas: Un array de hashes donde cada hash representa una región y cantidad vendida. Ej: [{region: :eu, cantidad: 100}, {region: :usa, cantidad: 50}].

## Métodos:

- to_s: Formato "TITULO: <titulo> (<genero>) - <precio>€".

## Comparable:

Un videojuego es "mayor" que otro basándose en su Recaudación Total (precio * total_de_todas_las_cantidades_vendidas).