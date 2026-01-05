require 'rspec'
require 'test/unit'

def limpiar_inventario(piezas)
    nuevas_piezas = piezas.reject{|x| x[:defectuosa]}.map{|n| n[:id]}
end

def verificar_calidad_lote(piezas, material_requerido)
    piezas_material = piezas.select{|n| n[:material] == material_requerido}
    !piezas_material.any?{|x| x[:peso] <= 10.0}
end

# -------------------------------------------------------------

RSpec.describe "Funcinalidades" do
    before(:each) do
        @p1 = { id: "A-01", material: :acero, peso: 15.5, defectuosa: false }
        @p2 = { id: "A-02", material: :acero, peso: 9.0, defectuosa: false }
        @p3 = { id: "B-01", material: :titanio, peso: 20.0, defectuosa: true } # Defectuosa
        @p4 = { id: "B-02", material: :titanio, peso: 12.0, defectuosa: false }
        @inventario = [@p1, @p2, @p3, @p4]
    end

    context "Pruebas para limpiar_inventario" do
        it "limpia las pieza p3 por defectuosa" do
            expect(limpiar_inventario(@inventario)).to eq(["A-01","A-02","B-02"])
        end
    end

    context "Pruebas para verificar_calidad_lote" do
        it "devuelve true para titanio" do
            expect(verificar_calidad_lote(@inventario, :titanio)).to be(true)
        end

        it "devuelve false para el acero" do
            expect(verificar_calidad_lote(@inventario, :acero)).to be(false)
        end
    end
end

# -----------------------------------------------------------------------------------------------

class TaquillaConcierto
    attr_reader :entradas_disponibles

    def initialize(entradas)
        @entradas_disponibles = entradas
        @mutex = Mutex.new
    end

    def comprar_entradas(cantidad, cliente)
        @mutex.synchronize do
            if (@entradas_disponibles >= cantidad)
                @entradas_disponibles -= cantidad
                puts "Cliente #{cliente} compra #{cantidad}. Quedan #{entradas_disponibles}"
            else
                puts "Cliente #{cliente} quiso #{cantidad} pero solo quedan #{entradas_disponibles}. Venta cancelada"
            end
        end
        sleep(rand(0.2..0.8))
    end
end

taquilla = TaquillaConcierto.new(50)

hilos = []
nombres = ["Ana", "Luis", "Maria", "Jorge", "Sofia"]

5.times do |i|
    hilos << Thread.new do
        numero_entradas = rand(10..15)
        taquilla.comprar_entradas(numero_entradas,"#{nombres[i]}")
    end
end

hilos.each(&:join)

# ---------------------------------------------------------------------------

class Examen
    include Comparable
    attr_reader :asignatura, :fecha, :nota, :presentado

    def initialize(asignatura,fecha,nota,presentado)
        @asignatura = asignatura
        @fecha = fecha
        @nota = nota
        @presentado = presentado
    end

    def <=>(otro)
        if otro.is_a?(Examen)
            (presentado ? nota : 0.0) <=> (otro.presentado ? otro.nota : 0.0)
        else
            nil
        end
    end

    def aprobado?
        (presentado && nota >= 5.0)
    end
end

# ---------------------------------------------------------------------------

class Test_Examen < Test::Unit::TestCase
    def setup
        @examen1 = Examen.new("LPP", "05/01/2024", 7.5, true)
        @examen2 = Examen.new("Cálculo", "23/04/2019", 9.0, false)
        @examen3 = Examen.new("Física", "19/08/2023", 4.0, true)
    end

    def test_herencia
        assert(@examen1.is_a?(Object))
        assert(@examen2.is_a?(Object))
        assert(@examen3.is_a?(Object))
    end

    def test_atributos
        assert_equal("LPP",@examen1.asignatura)
        assert_equal("05/01/2024", @examen1.fecha)
        assert_equal(7.5, @examen1.nota)
        assert(@examen1.presentado)
    end

    def test_comparable
        assert(@examen1 > @examen2)
        assert(@examen3 < @examen1)
    end

    def test_aprobado?
        assert(@examen1.aprobado?)
        assert(!@examen3.aprobado?)
    end
end