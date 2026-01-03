# EXAMEN DE LENGUAJES Y PARADIGMAS DE PROGRAMACIÓN

**Grado en Ingeniería Informática - Universidad de La Laguna**
**Tiempo estimado:** 1 hora 30 minutos

---

## 1. Programación Orientada a Objetos (Ruby)

Defina la clase `Proyecto` que cumpla con las siguientes especificaciones:

1. **Atributos de lectura:** `id` (entero), `nombre` (string), `categoria` (símbolo) y `tareas` (Array de Hashes).
2. **Constructor:** Inicializa los atributos.
* El atributo `tareas` es un array donde cada hash tiene la estructura: `{ nombre: String, horas: Float }`.


3. **Comparable:** Se debe incluir el mixin `Comparable`.
* Un proyecto es "mayor" que otro basándose en la **suma total de horas** de sus tareas.


4. **to_s:** Devuelve una cadena con el formato:
`"ID: <id>, CAT: <categoria>, TAREAS: <numero_de_tareas>, TOTAL_HORAS: <suma_horas>"`

---

## 2. Pruebas Unitarias (Test::Unit)

Escriba un conjunto de pruebas unitarias utilizando `Test::Unit` para la clase `Proyecto` definida anteriormente. Debe utilizar el siguiente `setup`:

```ruby
def setup
  @t1 = [{ nombre: "Diseño BD", horas: 10.5 }, { nombre: "API", horas: 20.0 }]
  @t2 = [{ nombre: "Frontend", horas: 50.0 }]
  @t3 = [{ nombre: "Testing", horas: 5.0 }, { nombre: "Deploy", horas: 2.0 }]

  @p1 = Proyecto.new(1, "Web Corporativa", :desarrollo, @t1) # Total horas: 30.5
  @p2 = Proyecto.new(2, "App Móvil", :desarrollo, @t2)       # Total horas: 50.0
  @p3 = Proyecto.new(3, "Auditoría", :consultoria, @t3)       # Total horas: 7.0
end

```

**Debe implementar los siguientes tests:**

1. Comprobar que la instancia hereda de `Object`.
2. Comprobar que el `id` es un número entero (`Integer`).
3. Comprobar que la `categoria` es un símbolo (`Symbol`).
4. Comprobar que `categoria` pertenece a la lista de categorías válidas: `[:desarrollo, :consultoria, :sistemas]`.
5. Comprobar que cada elemento dentro del array `tareas` es un `Hash`.
6. Comprobar que el método `to_s` devuelve un `String` y que contiene el texto `"TOTAL_HORAS: 30.5"` para el objeto `@p1`.
7. Comprobar el correcto funcionamiento del mixin `Comparable` (comprobar que `@p2 > @p1` y que `@p3 < @p1`).

---

## 3. Programación Funcional

Utilizando métodos de orden superior (`Enumerable`), implemente las siguientes funciones fuera de cualquier clase:

1. **`proyecto_mas_largo(proyectos)`**: Recibe un array de objetos `Proyecto` y devuelve el objeto proyecto que tiene la mayor cantidad de horas totales.
2. **`tarea_mas_costosa(proyectos, categoria)`**: Recibe un array de proyectos y una categoría (symbol). Debe devolver el **Hash** de la tarea individual con más horas de duración, buscando solo entre los proyectos de la categoría especificada. Si no hay proyectos de esa categoría, devuelve `nil`.

Escriba las pruebas para las funciones definidas en el apartado 3 utilizando **RSpec**. Asuma que existe un bloque `before` (o `setup`) con los mismos datos que en el apartado 2.

**Debe implementar las siguientes expectativas (`it`):**

1. `proyecto_mas_largo` devuelve el proyecto con más horas totales (en el caso del setup, debería ser `@p2`).
2. `tarea_mas_costosa` devuelve la tarea correcta cuando se busca en la categoría `:desarrollo` (debería ser `{ nombre: "Frontend", horas: 50.0 }`).
3. `tarea_mas_costosa` devuelve la tarea correcta cuando se busca en la categoría `:consultoria` (debería ser `{ nombre: "Testing", horas: 5.0 }`).
4. `tarea_mas_costosa` devuelve `nil` si se busca una categoría que no existe en la lista (ej: `:redes`).

---

## 4. Programación Concurrente

Implemente un programa en Ruby que simule un sistema de **Producción y Empaquetado** utilizando `Thread`, `Mutex` y `ConditionVariable` (Modelo Productor-Consumidor).

**Requisitos:**

1. Variables globales/compartidas:
* `cinta`: Un array vacío inicial.
* `lock`: Un objeto `Mutex`.
* `vacia_cv`, `llena_cv`: Variables condicionales.


2. Defina dos métodos:
* `producir(id)`: Imprime "Máquina <id> produce pieza", añade la cadena "Pieza<id>" al array `cinta`.
* `empaquetar`: Imprime "Operario empaqueta pieza", elimina el último elemento de `cinta`.


3. **Lógica de Hilos:**
* Cree un hilo **Máquina** que produzca 5 piezas. Debe usar el `lock` y notificar (`signal`) cuando haya producido.
* Cree un hilo **Operario** que intente empaquetar 5 piezas. Debe esperar (`wait`) si la cinta está vacía.


4. El programa debe asegurar la exclusión mutua al acceder a `cinta` y coordinar que el operario no intente empaquetar si no hay piezas.
5. Finalice el programa esperando a que ambos hilos terminen (`join`).