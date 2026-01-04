# EXAMEN DE LENGUAJES Y PARADIGMAS (Simulacro #3)

## 1. Programación Funcional (Algoritmos)

Suponga que tiene una lista de series representada como un Array de Hashes. Cada hash tiene la siguiente estructura:
`{ titulo: String, genero: Symbol, temporadas: Integer, valoracion: Float }`

Defina las siguientes funciones fuera de cualquier clase, utilizando **exclusivamente** métodos `Enumerable`:

1. **`maraton_fin_de_semana(series, genero_favorito)`**:
* Debe filtrar las series que sean del `genero_favorito`.
* De las resultantes, debe devolver un **Array con los títulos** (String) de aquellas que tengan **3 temporadas o menos** (ideales para ver en un finde).
* La lista devuelta debe estar ordenada alfabéticamente.


2. **`calidad_promedio(series)`**:
* Debe calcular la valoración media de **todas** las series de la lista.
* Devuelve un `Float`.
* Si la lista está vacía, debe devolver `0.0`.

---

## 2. TDD con RSpec (Testing de Funcional)

Escriba las pruebas para las funciones del Ejercicio 1 utilizando **RSpec**.

**Contexto (`before`):**

```ruby
@s1 = { titulo: "Breaking Bad", genero: :drama, temporadas: 5, valoracion: 9.5 }
@s2 = { titulo: "The Office", genero: :comedia, temporadas: 9, valoracion: 8.8 }
@s3 = { titulo: "Fleabag", genero: :comedia, temporadas: 2, valoracion: 9.2 }
@s4 = { titulo: "Chernobyl", genero: :drama, temporadas: 1, valoracion: 9.6 }
@s5 = { titulo: "Dark", genero: :scifi, temporadas: 3, valoracion: 9.0 }
@catalogo = [@s1, @s2, @s3, @s4, @s5]

```

**Debe implementar:**

1. Un test para `maraton_fin_de_semana` buscando el género `:drama`. Debería devolver `["Chernobyl"]` (Nota: Breaking Bad tiene 5 temporadas, no cuenta).
2. Un test para `maraton_fin_de_semana` buscando `:comedia`. Debería devolver `["Fleabag"]`.
3. Un test para `calidad_promedio` que verifique el cálculo correcto con `@catalogo`.
4. Un test para `calidad_promedio` con un array vacío `[]`.

---

## 3. Programación Concurrente (Buffer de Video)

Simule un sistema de **Streaming de Video**.

**Requisitos:**

* Clase `BufferVideo`.
* Recurso compartido: `buffer` (Array). Capacidad **ilimitada** para este ejercicio.
* Variables de control: `Mutex` y `ConditionVariable`.

**Métodos:**

1. **`descargar_chunk(id)`**:
* Simula la descarga de un fragmento de video.
* Añade "Chunk_#{id}" al `buffer`.
* Imprime: "Descargado Chunk_#{id}".
* Notifica al reproductor.
* **Importante:** La descarga (simulada con `sleep`) debe ocurrir **fuera** de la sección crítica para no bloquear.


2. **`reproducir`**:
* Bucle que intenta reproducir video continuamente.
* Si el buffer está vacío, muestra "Buffering..." y espera (`wait`).
* Si hay datos, extrae el primer elemento, imprime "Reproduciendo [Elemento]" y simula visualización (`sleep`).



**Main (Script):**

* Hilo **Descarga**: Baja 5 chunks (del 1 al 5).
* Hilo **Reproductor**: Consume contenido.
* Asegure que el programa termina correctamente después de procesar los 5 chunks.

---

## 4. Programación Orientada a Objetos (Ruby)

Defina la clase `UsuarioStreaming`.

1. **Atributos:** `nickname` (String), `plan` (Symbol: `:basico` o `:premium`), `historial` (Array de Hashes `{ serie: String, minutos: Integer }`).
2. **Constructor:** Inicializa los atributos.
3. **Mixin Comparable:**
* Un usuario es "menor" que otro si ha visto menos minutos totales de contenido (suma de minutos en su historial).


4. **Método `to_s`:**
* Formato: `"USER: <nickname> (<plan>) - TOTAL VISTO: <minutos_totales> min"`



---

## 5. Pruebas Unitarias (Test::Unit)

Escriba un test unitario para la clase `UsuarioStreaming` del ejercicio 4.

**Setup:**

* Usuario 1 (`:basico`) con 100 minutos vistos.
* Usuario 2 (`:premium`) con 500 minutos vistos.

**Tests:**

1. Comprobar herencia (`Object`).
2. Comprobar que el atributo `plan` es un Símbolo.
3. Comprobar que el método `to_s` devuelve el string con el formato correcto.
4. Comprobar que `Usuario 1 < Usuario 2` usando los operadores de comparación.

## EJERCICIO EXTRA DE HILOS
### Ejercicio: El Aparcamiento Subterráneo

Simule un sistema de control de acceso para un aparcamiento pequeño en el centro de la ciudad.

**Requisitos del Sistema:**

1. **Clase `Aparcamiento`:**
* Debe inicializarse con un número de **plazas totales** (capacidad máxima).
* Debe llevar la cuenta de **coches dentro**.
* Debe usar `Mutex` y `ConditionVariable` para sincronizar.


2. **Método `entrar(matricula)`:**
* Si hay plazas libres: El coche entra, incrementa el contador, imprime *"Coche [matricula] ha entrado. Plazas: X/Total"* y continúa.
* Si el aparcamiento está **LLENO**: El coche debe **esperar** (`wait`) hasta que alguien salga. Imprime *"Coche [matricula] esperando plaza..."* antes de dormirse.


3. **Método `salir(matricula)`:**
* El coche libera la plaza (decrementa contador).
* Imprime *"Coche [matricula] sale. Plazas libres disponibles"*.
* Debe avisar (`signal` o `broadcast`) a los coches que estén esperando en la cola.



**Script de Ejecución (`main`):**

* Cree un aparcamiento con solo **3 plazas**.
* Lance **10 hilos** (Coches).
* Cada hilo debe:
1. Intentar entrar.
2. Si lo consigue, simular que está aparcado un tiempo aleatorio (`sleep(rand(1..3))`).
3. Salir.

