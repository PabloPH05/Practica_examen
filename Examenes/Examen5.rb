require 'test/unit'
require 'rspec'
def informe_por_zona(sensores)
    sensores.group_by{|x| x[:zona]}
            .map{|zona, sensores_zona| [zona, sensores_zona.sum{|n| n[:temperatura]}/sensores_zona.size.to_f]}
            .to_h
end

def clasificar_estado(sensores)
    activos = sensores.select{|x| x[:activo]}.map{|n| n[:id]}
    desativados = sensores.select{|x| !x[:activo]}.map{|n| n[:id]}
    total = [activos, desativados]
end

sensor1 = { id: "S001", zona: :norte, temperatura: 22.5, activo: true }
sensor2 = { id: "S002", zona: :sur, temperatura: 18.3, activo: false }
sensor3 = { id: "S003", zona: :norte, temperatura: 21.8, activo: true }
sensor4 = { id: "S004", zona: :este, temperatura: 25.1, activo: true }
sensor5 = { id: "S005", zona: :oeste, temperatura: 19.7, activo: false }
sensores = [sensor1,sensor2,sensor3,sensor4,sensor5]

puts informe_por_zona(sensores)

# -------------------------------------------------------------------------------------------------

class Escena
    attr_reader :nombre, :instrucciones

    def initialize(nombre, &block)
        @nombre = nombre
        @instrucciones = []

        instance_eval(&block) if block_given?
    end

    def luces(potencia)
        instrucciones << {tipo: :luces, potencia: potencia}
    end

    def temperatura(grados)
        instrucciones << {tipo: :temp, grados: grados}
    end

    def persianas(instruccion)
        instrucciones << {tipo: :persianas, direccion: instruccion}
    end

    def alarma(estado)
        instrucciones << {tipo: :alarma, estado: estado}
    end

    def to_s
        salida = "ESCENA: #{@nombre}\n"
        instrucciones.each do |instr|
            case instr[:tipo]
            when :luces
                salida += "- Iluminación establecida a: #{instr[:potencia]}\n"
            when :temp
                salida += "- Termostato a: #{instr[:grados]} grados\n"
            when :persianas
                salida += "- Persianas: #{instr[:direccion]}\n"
            when :alarma
                salida += "- Seguridad: #{instr[:estado]}\n"
            end
        end
        salida
    end
end

modo_noche = Escena.new("Relax") do
  luces :tenue
  temperatura 24
  persianas :bajar
  alarma :activar
end

puts modo_noche

# -----------------------------------------------------------------------------

class EstacionCarga
    attr_reader :puertos_disponibles, :energia_total

    def initialize(puertos)
        @puertos_disponibles = puertos
        @energia_total = 0

        @mutex = Mutex.new
        @cv = ConditionVariable.new
    end

    def imprimir_carga_total
        @energia_total
    end

    def solicitar_carga(id_dron, carga_necesaria)
        @mutex.synchronize do
            while puertos_disponibles == 0
                puts "<#{id_dron}> está esperando a cargar ..."
                @cv.wait(@mutex)
            end

            puts "Dron <#{id_dron}> conectado."
            @puertos_disponibles -= 1
        end

        sleep(carga_necesaria.to_f/100)

        @mutex.synchronize do
            puts "Dron <#{id_dron}> cargado (#{carga_necesaria} %) y saliendo"
            @energia_total += carga_necesaria
            @puertos_disponibles += 1
            @cv.signal
        end
    end
end


estacion = EstacionCarga.new(3)
hilos = []

10.times do |i|
    hilos << Thread.new do
        carga_necesaria = rand(10..100)
        estacion.solicitar_carga("110-00#{i}", carga_necesaria)
    end
end


hilos.each(&:join)
puts estacion.imprimir_carga_total
        

# -----------------------------------------------------------------------------

class DispositivoIoT
    include Comparable
    attr_reader :id, :tipo, :bateria, :conectado

    def initialize(id, tipo, conectado, bateria = 100)
        @id = id
        @tipo = tipo
        @bateria = bateria
        @conectado = conectado
    end

    def estado_critico?
        return (@bateria <= 10 || !conectado)
    end

    def <=>(otro)
        if otro.is_a?(DispositivoIoT)
            bateria <=> otro.bateria
        else
            nil
        end
    end
end

class Test_Dispositivos < Test::Unit::TestCase
    def setup 
        @d1 = DispositivoIoT.new("TEST-1", :sensor, true, 8)
        @d2 = DispositivoIoT.new("TEST-2", :camara, false)
        @d3 = DispositivoIoT.new("TEST-3", :luz, true, 75)
    end

    def test_herencia
        assert(@d1.is_a?(Object))
        assert(@d2.is_a?(Object))
        assert(@d3.is_a?(Object))
    end

    def test_default
        assert_equal(100,@d2.bateria)
    end

    def test_estado_critico
        assert(@d1.estado_critico?)
        assert(@d2.estado_critico?)
        assert(!@d3.estado_critico?)
    end

    def test_comparable
        assert(@d1 < @d3)
        assert(@d2 > @d3)
        assert_equal(0, @d1 <=> DispositivoIoT.new("TEST-4", :sensor, true, 8))
        assert_nil(@d1 <=> "No es un dispositivo")
    end
end

RSpec.describe "Funcionalidades" do
    before(:all) do
        @sensores_rspec = [
            { id: "S001", zona: :salon, temperatura: 22.5, activo: true },
            { id: "S002", zona: :salon, temperatura: 20.3, activo: true },
            { id: "S003", zona: :cocina, temperatura: 24.1, activo: true }
        ]
    end

    it 'La media de salon es la adecuada' do
        expect(informe_por_zona(@sensores_rspec)[:salon]).to be_within(0.01).of(21.4)
    end
end