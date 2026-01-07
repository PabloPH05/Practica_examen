# EXAMEN DE LENGUAJES Y PARADIGMAS (Simulacro #5)

**Tema:** Sistema de Gestión de Edificios Inteligentes (Smart City).

## 1. Programación Funcional (Análisis de Sensores)

Se tiene una lista de registros (*logs*) de sensores. Cada registro es un Hash:
`{ id: String, zona: Symbol, temperatura: Float, activo: Boolean }`

Defina las siguientes funciones fuera de cualquier clase (Use `Enumerable`):

1. **`informe_por_zona(sensores)`**:
* Debe agrupar los sensores por su `zona`.
* Devolver un **Hash** donde la clave es la zona y el valor es la **temperatura media** de los sensores de esa zona.


2. **`clasificar_estado(sensores)`**:
* Debe devolver **dos arrays** separados dentro de un array padre `[ [activos], [inactivos] ]`.
* El primer array contiene los IDs de los sensores con `activo: true`.
* El segundo array contiene los IDs de los sensores con `activo: false`.



---

## 2. DSL (Automatización del Hogar)

Cree la clase `Escena` que permita configurar el ambiente de una habitación con esta sintaxis:

```ruby
modo_noche = Escena.new("Relax") do
  luces :tenue
  temperatura 24
  persianas :bajar
  alarma :activar
end

puts modo_noche
# Salida esperada:
# ESCENA: Relax
# - Iluminación establecida a: tenue
# - Termostato a: 24 grados
# - Persianas: bajar
# - Seguridad: activar

```

**Requisitos:**

* Métodos: `luces` (recibe símbolo), `temperatura` (entero), `persianas` (símbolo), `alarma` (símbolo).
* Almacenamiento: Guarde las instrucciones en un Hash o Array.

---

## 3. Programación Concurrente (Estación de Carga de Drones)

Simule una estación de carga para drones de reparto.

**Escenario:**

* Hay **3 puertos de carga** (recurso limitado).
* Llegan **10 drones** que necesitan cargar.
* Existe un **Contador Global de Energía** (variable compartida) que suma cuánta energía ha recargado cada dron.

**Clase `EstacionCarga`:**

1. **`initialize`**: 3 puertos disponibles. Mutex y variable para energía total.
2. **`solicitar_carga(id_dron, carga_necesaria)`**:
* Si no hay puertos libres, el dron espera.
* Cuando entra, imprime "Dron [id] conectado".
* Simula la carga (`sleep`).
* **Suma** la `carga_necesaria` al contador global de energía (¡Cuidado con la Race Condition aquí!).
* Libera el puerto e imprime "Dron [id] cargado y saliendo".
* Notifica a los drones en espera.



**Main:**

* Lance 10 hilos (drones). Cada uno pide una carga aleatoria (10..50 unidades).
* Al final, imprima el **Total de Energía Suministrada** por la estación.

---

## 4. Programación Orientada a Objetos (Ruby)

Defina la clase `DispositivoIoT`.

1. **Atributos:** `id` (String), `tipo` (:luz, :sensor, :camara), `bateria` (Integer 0-100), `conectado` (Boolean).
2. **Constructor:** Inicializa atributos. Si no se pasa batería, por defecto es 100.
3. **Método `estado_critico?**`: Devuelve `true` si la batería es menor al 10% O si está desconectado.
4. **Mixin Comparable:**
* Un dispositivo es "mayor" que otro si tiene **más batería**.


---

## 5. Tests (Mezcla RSpec y Unit)

1. **Test Unitario (Test::Unit) para `DispositivoIoT**`:
* Cree un dispositivo con 5% de batería. Compruebe que `estado_critico?` devuelve `true`.
* Cree dos dispositivos y compruebe que el operador `<` funciona correctamente según la batería.


2. **Test RSpec para `informe_por_zona` (Ejercicio 1)**:
* Contexto: 3 sensores (2 en :salon, 1 en :cocina).
* Expectativa: Comprobar que la clave `:salon` del hash resultante tiene el valor correcto de la media de temperatura.
