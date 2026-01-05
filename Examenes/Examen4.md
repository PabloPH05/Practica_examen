# EXAMEN DE LENGUAJES Y PARADIGMAS (Simulacro #4)

## 1. Programación Funcional (Inventario de Piezas)

Suponga un inventario de piezas mecánicas representado como una lista de Hashes.
Estructura: `{ id: String, material: Symbol, peso: Float, defectuosa: Boolean }`

Defina las siguientes funciones fuera de cualquier clase (Use `Enumerable`):

1. **`limpiar_inventario(piezas)`**:
* Debe devolver una lista nueva que **excluya** (elimine) todas las piezas que estén marcadas como `defectuosa: true`.
* De las piezas restantes (las buenas), debe devolver solo una lista con los **IDs** (String).


2. **`verificar_calidad_lote(piezas, material_requerido)`**:
* Debe devolver `true` **solo si TODAS** las piezas del `material_requerido` pesan más de 10.0 gramos.
* Si alguna pieza de ese material pesa 10.0 o menos, devuelve `false`.
* Si no hay piezas de ese material, devuelve `true` (vacuamente cierto).



---

## 2. TDD con RSpec (Funcional)

Implemente los tests para el ejercicio anterior.

**Datos (`before`):**

```ruby
@p1 = { id: "A-01", material: :acero, peso: 15.5, defectuosa: false }
@p2 = { id: "A-02", material: :acero, peso: 9.0, defectuosa: false }
@p3 = { id: "B-01", material: :titanio, peso: 20.0, defectuosa: true } # Defectuosa
@p4 = { id: "B-02", material: :titanio, peso: 12.0, defectuosa: false }
@inventario = [@p1, @p2, @p3, @p4]

```

**Tests:**

1. `limpiar_inventario`: Compruebe que elimina a `@p3` y devuelve los IDs correctos `["A-01", "A-02", "B-02"]`.
2. `verificar_calidad_lote`:
* Para `:titanio`, debe devolver `true` (La única pieza de titanio *no defectuosa* y *defectuosa* no importa aquí, el enunciado dice "todas las piezas del material". *Ojo: lee bien tu propia implementación, normalmente se valida sobre el total*). -> **Aclaración**: Verifica sobre todas las piezas del material dado, sean defectuosas o no.
* Para `:acero`, debe devolver `false` (porque `@p2` pesa 9.0).



---

## 3. Programación Concurrente (Venta de Entradas)

Simule un sistema de **Venta de Entradas para un Concierto**.

**Requisitos:**

* Clase `TaquillaConcierto`.
* Recurso compartido: `entradas_disponibles` (Inicialmente un número entero, ej: 100).
* No se requiere `ConditionVariable` (no hay que esperar a que se repongan entradas, solo se venden hasta agotar).

**Métodos:**

1. **`comprar_entradas(cantidad, cliente)`**:
* El cliente intenta comprar X entradas.
* Debe proteger el acceso para evitar vender más entradas de las que existen.
* **Lógica:**
* Si hay suficientes entradas: Resta del total, imprime "Cliente <cliente> compra <cantidad>. Quedan <restantes>". Devuelve `true`.
* Si NO hay suficientes: Imprime "Cliente <cliente> quiso <cantidad> pero solo quedan <restantes>. Venta cancelada". Devuelve `false`.


* Simule un pequeño retardo (`sleep`) dentro de la compra para forzar la concurrencia.



**Script (`main`):**

* Inicie la taquilla con **50 entradas**.
* Lance **5 hilos** (Clientes). Cada cliente intenta comprar un número aleatorio de entradas entre 10 y 15.
* Asegure con `join` que todos terminan.

---

## 4. Programación Orientada a Objetos (Ruby)

Defina la clase `Examen`.

1. **Atributos:** `asignatura` (String), `fecha` (String), `nota` (Float), `presentado` (Boolean).
2. **Constructor:** Inicializa los atributos.
3. **Mixin Comparable:**
* Un examen es "mayor" que otro si su `nota` es más alta.
* *Excepción:* Si un examen tiene `presentado: false`, su nota se considera 0.0 a efectos de comparación, independientemente del valor del atributo `nota`.


4. **Método `aprobado?**`: Devuelve `true` si `presentado` es verdadero Y la `nota` es >= 5.0.

---

## 5. Pruebas Unitarias (Test::Unit)

Tests para la clase `Examen`.

**Setup:**

* Examen 1: LPP, Nota 7.5, Presentado: true.
* Examen 2: Cálculo, Nota 9.0, Presentado: false (No presentado).
* Examen 3: Física, Nota 4.0, Presentado: true.

**Tests:**

1. Comprobar que `Examen 2` no está `aprobado?`.
2. Comprobar que `Examen 1` es mayor que `Examen 2` (Recordando la regla del no presentado).
3. Comprobar que `Examen 3` es menor que `Examen 1`.
4. Comprobar que `Examen 1` está `aprobado?`.
