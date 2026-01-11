# EXAMEN DE LENGUAJES Y PARADIGMAS (Simulacro #7)

**Nivel:** Avanzado | **Tiempo:** 1h 30m

## 1. POO + Funcional (La Tubería de Datos)

Diseña una clase `Pipeline` que permita encadenar operaciones de transformación de datos de manera funcional.

* Debe inicializarse con un dato semilla (input).
* Debe tener un método `paso` que reciba un bloque (o un Proc). Este bloque transforma el dato.
* Debe tener un método `filtro` que reciba un bloque. Si el bloque devuelve `false`, se detiene el procesamiento y devuelve `nil` (o un objeto nulo).
* Debe tener un método `resultado` que devuelva el valor final tras pasar por todos los pasos.
* **Requisito:** La ejecución debe ser **perezosa** (lazy) o diferida; es decir, las operaciones no se ejecutan hasta que llamo a `resultado`.

```ruby
# Ejemplo de uso deseado:
proceso = Pipeline.new([1, 2, 3, 4])
  .paso { |nums| nums.map { |n| n * 2 } }
  .filtro { |nums| nums.sum > 10 }
  .paso { |nums| nums.join("-") }

puts proceso.resultado # Debería salir "2-4-6-8" (si pasa el filtro)

```

---

## 2. Concurrencia (El Puente Estrecho)

Implementa un sistema de control para un puente donde **solo pueden pasar coches en una dirección a la vez**.

* Clase `Puente`.
* Métodos: `entrar_norte`, `salir_norte`, `entrar_sur`, `salir_sur`.
* Reglas:
* Si hay coches cruzando hacia el SUR, los del NORTE deben esperar (`wait`).
* Pueden pasar varios coches en la *misma* dirección a la vez (hasta un límite de 3).
* Usa `Monitor` o `Mutex` + `ConditionVariable`.


* **Reto:** Evita la "inanición" (que los del Sur nunca pasen si no paran de llegar coches del Norte).

---

## 3. DSL "Bien Bonito" (Generador de HTML)

Crea un DSL para generar código HTML simple pero con una sintaxis súper limpia.

* Debe soportar anidamiento infinito.
* Los atributos (clase, id, style) deben pasarse como hash.
* El contenido de texto va como argumento o bloque.

```ruby
# Uso esperado:
html = Documento.new do
  body do
    div class: "contenedor", id: "main" do
      h1 "Titulo Principal"
      ul do
        li "Elemento 1"
        li "Elemento 2", class: "destacado"
      end
    end
  end
end

puts html
# Salida esperada:
# <body>
#   <div class="contenedor" id="main">
#     <h1>Titulo Principal</h1>
#     <ul>
#       <li>Elemento 1</li>
#       <li class="destacado">Elemento 2</li>
#     </ul>
#   </div>
# </body>

```

---

## 4. Funciones Puras (Refactorización)

El siguiente código es un desastre: modifica variables globales, imprime por pantalla dentro de la lógica y depende del estado externo.
**Tu misión:** Rescríbelo usando **una única función pura** que reciba todo lo necesario y devuelva un resultado nuevo, sin efectos secundarios. Separa la lógica "impura" (IO) fuera.

```ruby
# CÓDIGO SUCIO (A REFACTORIZAR):
$tasa_cambio = 1.1
$historial = []

def calcular_precio(precio_base)
  impuesto = precio_base * 0.21
  total = (precio_base + impuesto) * $tasa_cambio
  puts "Calculando precio para #{precio_base}..."
  $historial << total
  return total
end

calcular_precio(100)

```

* **Pregunta:** Escribe la versión "Pura" y luego cómo la llamarías desde un script principal.