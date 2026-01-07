def usuarios_intensos(sesiones, tipo_ejercicio)
    filtro_usuarios = sesiones.select{|x| x[:tipo] == tipo_ejercicio}
    filtro_usuarios.select{|n| n[:calorias] > 500}.map{|m| m[:usuario]}.sort.uniq
end

def promedio_minutos(sesiones)
    if sesiones.empty? 
        return 0.0
    end
    sesiones.sum{|x| x[:duracion]} / sesiones.size.to_f
end


sesiones = [
    { usuario: "Juan", tipo: :cardio, duracion: 30, calorias: 450 },
    { usuario: "María", tipo: :cardio, duracion: 45, calorias: 620 },
    { usuario: "Pedro", tipo: :fuerza, duracion: 60, calorias: 480 },
    { usuario: "Ana", tipo: :cardio, duracion: 40, calorias: 580 },
    { usuario: "Luis", tipo: :yoga, duracion: 50, calorias: 300 }
]

puts usuarios_intensos(sesiones,:cardio)
puts promedio_minutos(sesiones)
puts promedio_minutos([])

# ---------------------------------------------------------------------------

class Rutina
    attr_reader :nombre, :pasos
    
    def initialize(nombre, &block)
        @nombre = nombre
        @pasos = []

        instance_eval(&block) if block_given?
    end

    def ejercicio(nombre, opciones)
        pasos << {nombre: nombre, opciones: opciones}
    end

    def descanso(segundos)
        pasos << {nombre: "", opciones: segundos}
    end

    def hidratacion()
        pasos << {nombre: "Beber agua", opciones: {}}
    end

    def to_s
        salida = "RUTINA: #{@nombre}\n"
        pasos.each do |paso|
            if paso[:nombre] == "Beber agua\n"
                salida += "- #{paso[:nombre]}"
            elsif paso[:nombre].empty?
                salida += "- Descanso: #{paso[:opciones]} seg\n"
            else
                salida += "- Ejercicio: #{paso[:nombre]} (#{paso[:opciones][:series]} series)\n"
            end
        end
        salida
    end
end

# Main
mi_rutina = Rutina.new("Espalda y Bíceps") do
  ejercicio "Dominadas", series: 4
  descanso 60
  ejercicio "Remo", series: 3
  hidratacion
end

puts mi_rutina

