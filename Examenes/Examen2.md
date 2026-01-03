# EXAMEN LENGUAJES Y PARADIGMAS (Simulacro #2)

**Tiempo:** 90 minutos
**Normas:** Sin internet, sin IDE (usa un editor de texto plano o papel).

---

## 1. Programación Orientada a Objetos (Ruby)

Defina la clase `Jugador` con las siguientes características:

1. **Atributos de lectura:** `nickname` (String), `equipo` (Symbol), `region` (String) y `estadisticas` (Array de Hashes).
2. **Constructor:** Inicializa los atributos.
* El array `estadisticas` contiene hashes con la forma: `{ partidas: Integer, winrate: Float }`. (Ej: `{ partidas: 10, winrate: 55.5 }`).


3. **Método to_s:** Devuelve un string con el formato exacto:
`"PLAYER: <nickname> [<equipo>], REGION: <region>, DATA: <total_partidas> games"`
4. **Mixin Comparable:**
* Un jugador es "mayor" que otro basándose en su **Puntuación de Eficiencia**.
* La fórmula de eficiencia es: `Suma total de partidas * Promedio de winrate`.
* *Nota:* Si el jugador no tiene estadísticas, su eficiencia es 0.



---

## 2. Pruebas Unitarias (Test::Unit)

Escriba la clase `TestJugador` heredando de `Test::Unit::TestCase`. Utilice el siguiente `setup`:

```ruby
def setup
  @s1 = [{ partidas: 20, winrate: 50.0 }, { partidas: 10, winrate: 60.0 }] 
  # Eficiencia s1: (20+10) * ((50+60)/2) = 30 * 55 = 1650
  
  @s2 = [{ partidas: 100, winrate: 40.0 }] 
  # Eficiencia s2: 100 * 40 = 4000
  
  @s3 = [{ partidas: 5, winrate: 10.0 }] 
  # Eficiencia s3: 5 * 10 = 50

  @j1 = Jugador.new("Faker", :t1, "KR", @s1)
  @j2 = Jugador.new("Caps", :g2, "EU", @s2)
  @j3 = Jugador.new("Rookie", :ig, "CN", @s3)
end

```

**Implemente los siguientes tests:**

1. **Herencia:** Verifique que `@j1` es instancia de `Object` y `BasicObject`.
2. **Tipos:** Verifique que `equipo` es un Symbol y `estadisticas` es un Array.
3. **Contenido:** Recorra `@j1.estadisticas` y verifique que cada elemento es un Hash y que la clave `:winrate` es de tipo `Float`.
4. **Validación:** Verifique que el equipo de `@j1` está incluido en la lista de equipos permitidos: `[:t1, :g2, :fnatic, :ig]`.
5. **Formato:** Verifique mediante una expresión regular (`assert_match`) que el `to_s` de `@j1` contiene el texto "PLAYER: Faker" y "DATA: 2 games" (suponiendo que data muestra el tamaño del array).
6. **Comparación:** Verifique que `@j2 > @j1` y que `@j3 < @j1`.

---

## 3. Programación Funcional

Fuera de cualquier clase, defina las siguientes funciones utilizando **únicamente** métodos de `Enumerable` (`map`, `select`, `reduce`, `max_by`, etc.):

1. **`region_mas_activa(jugadores)`**: Recibe un array de jugadores. Devuelve el **String** de la región que acumula más partidas jugadas en total (sumando las partidas de todos los jugadores de esa región).
2. **`buscar_prodigio(jugadores, equipo, winrate_minimo)`**:
* Filtra los jugadores del `equipo` dado.
* De esos, busca aquel que tenga en alguna de sus estadísticas individuales un winrate **superior** al `winrate_minimo`.
* Si hay varios, devuelve el que tenga menos partidas totales jugadas (el más "nuevo" pero talentoso).
* Devuelve el objeto `Jugador` o `nil`.

Escriba las pruebas para las funciones del apartado 3. Asuma un `before` con los datos del apartado 2.

**Specs a implementar:**

1. `region_mas_activa`: Debe devolver `"EU"` (basado en los datos del setup, ya que @j2 tiene 100 partidas, muchas más que el resto).
2. `buscar_prodigio`:
* Buscando en equipo `:t1` con winrate min 55.0, debe devolver a `@j1` (tiene un hash con 60.0).
* Buscando en equipo `:g2` con winrate min 90.0, debe devolver `nil`.
* Buscando en un equipo que no existe (`:tsm`), debe devolver `nil`.



---

## 5. Programación Concurrente (Producer-Consumer)

Simule un **Servidor de Procesamiento de Replays**.

**Contexto:**

* Clase `ServidorReplays`.
* Recursos compartidos: `cola_replays` (Array), `mutex`, `cv_nueva_replay`.

**Requisitos:**

1. Método `subir_replay(nombre_archivo)`:
* Simula (print) que un usuario sube un archivo.
* Añade el archivo a `cola_replays` de forma segura (`synchronize`).
* Avisa al hilo procesador (`signal`).


2. Método `procesar_replays`:
* Se ejecuta en un bucle infinito (o hasta procesar X elementos).
* Si la cola está vacía, debe esperar (`wait`) a que lleguen archivos.
* Si hay archivo, lo saca (`shift`), imprime "Analizando <archivo>..." y duerme 0.2 segundos.



**Script de ejecución (`main`):**

* Inicie **1 hilo Servidor** que se quede esperando archivos.
* Inicie **1 hilo Cliente** que suba 4 replays ("game1.rec", "game2.rec"...) con una pausa pequeña entre cada subida.
* Asegúrese de que el programa no termine abruptamente antes de procesar los archivos (use `join` o un mecanismo de parada).