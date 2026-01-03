require 'test/unit'
require 'rspec'
class Proyecto
    include Comparable
    attr_reader :id, :nombre, :categoria, :tareas

    def initialize (id, nombre, categoria, tareas=[])
        @id = id
        @nombre = nombre
        @categoria = categoria
        @tareas = tareas
    end

    def suma_total_horas
        tareas.sum{|x| x[:horas]}
    end

    def <=>(otro)
        if otro.is_a?(Proyecto)
            suma_total_horas <=> otro.suma_total_horas
        else
            nil
        end
    end

    def to_s
        "ID: #{id}, CAT: #{categoria}, TAREAS: #{tareas.size}, TOTAL_HORAS: #{suma_total_horas}"
    end
end

# -----------------------------------------------------------------------------------

class Test_Proyecto < Test::Unit::TestCase
    def setup
        @t1 = [{ nombre: "Diseño BD", horas: 10.5 }, { nombre: "API", horas: 20.0 }]
        @t2 = [{ nombre: "Frontend", horas: 50.0 }]
        @t3 = [{ nombre: "Testing", horas: 5.0 }, { nombre: "Deploy", horas: 2.0 }]

        @p1 = Proyecto.new(1, "Web Corporativa", :desarrollo, @t1) # Total horas: 30.5
        @p2 = Proyecto.new(2, "App Móvil", :desarrollo, @t2)       # Total horas: 50.0
        @p3 = Proyecto.new(3, "Auditoría", :consultoria, @t3)       # Total horas: 7.0
    end

    def test_herencia
        assert(@p1.is_a?(Object))
        assert(@p2.is_a?(Object))
        assert(@p3.is_a?(Object))
    end

    def test_id
        assert(@p1.id.is_a?(Integer))
    end

    def test_cat
        assert(@p2.categoria.is_a?(Symbol))
    end

    def test_valid_cat
        assert_includes([:desarrollo, :consultoria, :sistemas], @p3.categoria)
    end

    def test_tareas
        @p1.tareas.each do |tarea|
            assert(tarea.is_a?(Hash))
        end
    end

    def test_to_s
        str = @p1.to_s
        assert(str.is_a?(String))
        assert_includes(str, "TOTAL_HORAS: 30.5")
    end

    def test_comparable
        assert(@p2 > @p1)
        assert(@p3 < @p1)
    end
end

# -----------------------------------------------------------------------------------

def proyecto_mas_largo(proyectos)
    proyectos.max
end

def tarea_mas_costosa(proyectos, categoria)
    proyectos_categoria = proyectos.select{|p| p.categoria == categoria}
    tareas_filtradas = proyectos_categoria.flat_map{|x| x.tareas}
    tareas_filtradas.max_by{|x| x[:horas]}
end

# -----------------------------------------------------------------------------------

RSpec.describe Proyecto do
    before(:each) do
        @t1 = [{ nombre: "Diseño BD", horas: 10.5 }, { nombre: "API", horas: 20.0 }]
        @t2 = [{ nombre: "Frontend", horas: 50.0 }]
        @t3 = [{ nombre: "Testing", horas: 5.0 }, { nombre: "Deploy", horas: 2.0 }]

        @p1 = Proyecto.new(1, "Web Corporativa", :desarrollo, @t1) # Total horas: 30.5
        @p2 = Proyecto.new(2, "App Móvil", :desarrollo, @t2)       # Total horas: 50.0
        @p3 = Proyecto.new(3, "Auditoría", :consultoria, @t3)       # Total horas: 7.0
    end

    context "Pruebas para proyecto_mas_largo" do
        it "devuelve el proyecto más largo" do
            expect(proyecto_mas_largo([@p1,@p2,@p3])).to eq(@p2)
        end
    end

    context "Pruebas para tarea_mas_costosa" do
        it "devuelve el resultado correcto para categorias incluidas" do
            expect(tarea_mas_costosa([@p1,@p2,@p3],:desarrollo)).to eq({ nombre: "Frontend", horas: 50.0 })
            expect(tarea_mas_costosa([@p1,@p2,@p3],:consultoria)).to eq({nombre: "Testing", horas: 5.0 })
        end

        it "devuelve nil para catagorias que no estan en la lista" do
            expect(tarea_mas_costosa([@p1,@p2,@p3],:redes)).to eq(nil)
        end
    end
end

class Fabrica
    attr_reader :cinta

    def initialize
        @cinta = []
        @mutex = Mutex.new
        @vacia_cv = ConditionVariable.new
        @llena_cv = ConditionVariable.new
    end

    def producir(id)
        @mutex.synchronize do
            puts "Máquina <#{id}> produce pieza"
            @cinta << "Pieza <#{id}>"
            sleep(0.5)
            @llena_cv.signal
        end
    end

    def empaquetar
        @mutex.synchronize do
            while @cinta.empty? do
                @llena_cv.wait(@mutex)
            end
            paquete = @cinta.shift
            puts "Se empaqueta #{paquete}"
            sleep(0.5)
            @vacia_cv.signal
        end
    end
end

fabrica = Fabrica.new
hilos = []

5.times do |i|
    hilos << Thread.new do
        fabrica.producir(i)
    end
    hilos << Thread.new do
        fabrica.empaquetar
    end
end

hilos.each(&:join)