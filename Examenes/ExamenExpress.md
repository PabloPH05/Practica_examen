# EXAMEN DE LENGUAJES Y PARADIGMAS (EXPRESS)
## 1. Programación Funcional: Análisis de Rendimiento

Tienes una lista de sesiones de entrenamiento representadas como un Array de Hashes:
`{ usuario: String, tipo: Symbol, duracion: Integer, calorias: Integer }`
*(Duración en minutos)*.

Defina las siguientes funciones fuera de cualquier clase:

1. **`usuarios_intensos(sesiones, tipo_ejercicio)`**:
* Debe filtrar las sesiones del `tipo_ejercicio` (ej: `:cardio`).
* De esas, quedarse con las que hayan quemado **más de 500 calorías**.
* Devolver un **Array con los nombres de los usuarios**, ordenados alfabéticamente y sin repetir nombres (si un usuario tiene varias sesiones intensas, solo aparece una vez).


2. **`promedio_minutos(sesiones)`**:
* Calcular la duración media de **todas** las sesiones de la lista.
* Devolver un `Float`.
* Si la lista está vacía, devolver `0.0`.

---

## 2. DSL (Domain Specific Language): Rutina de Gimnasio

Crea una clase `Rutina` que permita definir entrenamientos con la siguiente sintaxis exacta:

```ruby
# Sintaxis deseada (Código cliente):
mi_rutina = Rutina.new("Espalda y Bíceps") do
  ejercicio "Dominadas", series: 4
  descanso 60
  ejercicio "Remo", series: 3
  hidratacion
end

puts mi_rutina
# Salida esperada:
# RUTINA: Espalda y Bíceps
# - Ejercicio: Dominadas (4 series)
# - Descanso: 60 seg
# - Ejercicio: Remo (3 series)
# - Beber agua

```

**Requisitos de la clase `Rutina`:**

1. **Initialize:** Recibe el nombre y el bloque. Debe usar `instance_eval` para ejecutar el bloque dentro del objeto.
2. **Método `ejercicio`:** Recibe el nombre (String) y un hash de opciones (ej: `series: 4`). Guarda esto en una lista interna de pasos.
3. **Método `descanso`:** Recibe un entero (segundos). Guarda un paso de tipo descanso.
4. **Método `hidratacion`:** No recibe argumentos. Guarda un paso que indique "Beber agua".
5. **Método `to_s`:** Devuelve el string formateado como en el ejemplo.
