# EXAMEN DE LENGUAJES Y PARADIGMAS (Simulacro #6 - Nivel: Experto)

**Tema:** Sistema Bancario de Alta Frecuencia & Trading.

## 1. Programación Funcional (La "Auditoría")

Tienes una lista de millones de transacciones. Cada una es un Hash:
`{ id: String, divisa: Symbol, cantidad: Integer, tipo: :compra/:venta, riesgo: Float }`

Defina **una única función** `resumen_mercado(transacciones)` que devuelva un Hash con la siguiente estructura exacta:

```ruby
{
  :eur => { volumen_total: 15000, riesgo_medio: 0.45 },
  :usd => { volumen_total: 32000, riesgo_medio: 0.12 }
}

```

**Restricciones:**

1. Debes calcular el volumen total (suma de cantidades absolutas) y el riesgo medio por divisa.
2. **RETO:** Intenta hacerlo usando `each_with_object` o `reduce` (inject) para recorrer la lista **una sola vez**. (Si usas `group_by` + `map`, también vale, pero es menos eficiente en memoria para millones de datos).

---

## 2. DSL (Motor de Reglas de Fraude)

Necesitamos un sistema flexible para definir reglas de bloqueo de tarjetas. Fíjate que ahora **hay anidamiento**.

```ruby
filtro = MotorFraude.new("Reglas BlackFriday") do
  bloquear_pais :rusia
  bloquear_pais :corea_norte
  
  cuando_monto_mayor 1000 do
    exigir :sms
    bloquear_tipo :tarjeta_prepago
  end
  
  cuando_monto_mayor 5000 do
    exigir :llamada_banco
  end
end

puts filtro
# Salida esperada:
# REGLAS: Reglas BlackFriday
# - Bloquear procedencia: rusia
# - Bloquear procedencia: corea_norte
# - CONDICIÓN (> 1000):
#   * Exigir: sms
#   * Bloquear tipo: tarjeta_prepago
# - CONDICIÓN (> 5000):
#   * Exigir: llamada_banco

```

---

## 3. Concurrencia (El Buffer Circular)

Implementa el patrón **Productor-Consumidor** con un buffer de tamaño fijo.

**Clase `BufferBursatil`:**

1. `initialize(capacidad)`: Crea un array vacío y guarda la capacidad máxima.
2. `producir(orden)`:
* Si el buffer está **LLENO**, el hilo debe esperar (`wait`).
* Si hay hueco, añade la orden al final.
* Imprime: "Nueva orden [ID]. Buffer: X/MAX".
* Avisa a los consumidores (`signal`).


3. `consumir`:
* Si el buffer está **VACÍO**, el hilo debe esperar (`wait`).
* Si hay datos, saca la primera orden (FIFO).
* Imprime: "Procesada orden [ID]. Buffer: X/MAX".
* Avisa a los productores (`signal`).



**Main:**

* 1 Buffer de capacidad 5.
* 2 Hilos Productores (generan órdenes infinitamente, rápido).
* 2 Hilos Consumidores (procesan órdenes infinitamente, lento).
* Usa `sleep` para simular las velocidades.

---

## 4. POO & Metaprogramación (`method_missing`)

En Ruby, cuando llamas a un método que no existe, se invoca `method_missing`. Vamos a usarlo para crear un **Proxy de Auditoría**.

Crea la clase `AuditProxy`.

1. **Initialize:** Recibe un objeto real (el "target") cualquiera (ej: un String, un Array, tu clase DispositivoIoT...).
2. **Comportamiento Mágico:**
* Si llamas a cualquier método sobre el proxy (ej: `proxy.upcase`), este debe:
1. Imprimir: "LOG: Llamando al método [nombre_metodo]..."
2. **Delegar** la llamada al objeto real y devolver su resultado.


* Si el objeto real no tiene ese método, debe fallar como es habitual (`super`).



**Ejemplo de uso:**

```ruby
string_real = "hola mundo"
proxy = AuditProxy.new(string_real)

puts proxy.upcase 
# Salida:
# LOG: Llamando al método upcase...
# HOLA MUNDO

puts proxy.reverse
# Salida:
# LOG: Llamando al método reverse...
# odnum aloh

```