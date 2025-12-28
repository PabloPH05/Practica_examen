### 🏰 El Enunciado: "Gestión de Torneos Medievales"

Crea una clase `Caballero` que cumpla:

1. **Atributos:** `nombre` (String), `casa` (Symbol, ej: `:stark`), `victorias` (Integer), `puntos_fuerza` (Float).
2. **Comparable:** Un caballero es "mayor" que otro basándose en sus `victorias`.
3. **Funcional (Sin bucles):**
* Crea un array con 5 caballeros.
* `mejor_casa(caballeros)`: Devuelve la Casa (Symbol) que suma más victorias en total entre todos sus miembros.
* `guardia_real(caballeros)`: Devuelve en foramto string ("Nombre (Casa)") y ordenados de mayor a menor aquellos caballeros que poseen una fuerza superior a 8.

**Reglas:**

* Hazlo con **TDD** (primero el test, luego el código) para la clase.
* Para la parte funcional, usa solo encadenamiento de métodos (`Enumerable`).