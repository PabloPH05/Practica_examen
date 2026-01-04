require 'rspec'
require 'test/unit'


def maraton_fin_de_semana(series, genero)
    series.select{|x| x[:genero] == genero && x[:temporadas] <= 3}
          .map{|i| i[:titulo]}
end

def calidad_promedio(series)
    if series.empty?
        return 0.0
    end
    series.map{|x| x[:valoracion]}.sum()/series.size
end


# -----------------------------------------------------------------------------

RSpec.describe "Funciones" do
    before(:each) do
        @s1 = { titulo: "Breaking Bad", genero: :drama, temporadas: 5, valoracion: 9.5 }
        @s2 = { titulo: "The Office", genero: :comedia, temporadas: 9, valoracion: 8.8 }
        @s3 = { titulo: "Fleabag", genero: :comedia, temporadas: 2, valoracion: 9.2 }
        @s4 = { titulo: "Chernobyl", genero: :drama, temporadas: 1, valoracion: 9.6 }
        @s5 = { titulo: "Dark", genero: :scifi, temporadas: 3, valoracion: 9.0 }
        @catalogo = [@s1, @s2, @s3, @s4, @s5]
    end

    describe "Pruebas para maraton_fin_de_semana" do
        it "devuelve la serie adecuada" do
            expect(maraton_fin_de_semana(@catalogo, :drama)).to eq(["Chernobyl"])
            expect(maraton_fin_de_semana(@catalogo, :comedia)).to eq(["Fleabag"])
        end
    end

    describe "Pruebas para calidad_promedio" do
        it "devuelve la calidad adecuada" do
            expect(calidad_promedio(@catalogo)).to eq(9.22)
        end

        it "devuelve 0 para una lista vacia" do
            expect(calidad_promedio([])).to eq(0.0)
        end
    end
end

# -----------------------------------------------------------------------------

class BufferVideo
    attr_reader :buffer
    
    def initialize
        @buffer = []
        @mutex = Mutex.new
        @cv_video = ConditionVariable.new
    end

    def descargar_chunk(id)
        @mutex.synchronize do
            chunk = "Chunk(#{id})"
            @buffer << chunk
            puts "Descargando #{chunk}"
            @cv_video.signal
        end
        sleep(0.5)
    end

    def reproducir
        @mutex.synchronize do
            while @buffer.empty? do
                puts "Buffering..."
                @cv_video.wait(@mutex)
            end

            chunk_procesado = @buffer.shift
            puts "Reproduciendo #{chunk_procesado}"
        end
        sleep(1)
    end
end

buffer = BufferVideo.new
hilo_reproductor = Thread.new do
    loop do
        buffer.reproducir
    end
end 

hilo_descarga = Thread.new do
    5.times do |i|
        buffer.descargar_chunk(i)
    end
end

hilo_descarga.join
sleep(2)
hilo_reproductor.kill

# -----------------------------------------------------------------------------

class UsuarioStreaming
    include Comparable
    attr_reader :nickname, :plan, :historial

    def initialize(nickname, plan, historial = [])
        @nickname = nickname
        @plan = plan
        @historial = historial
    end

    def minutos_totales
        @historial.sum{|x| x[:minutos]}
    end

    def <=>(otro)
        if otro.is_a?(UsuarioStreaming)
            minutos_totales <=> otro.minutos_totales
        else
            nil
        end
    end

    def to_s
        "USER: #{nickname} (#{plan}) - TOTAL VISTO: #{minutos_totales} min"
    end

end

# ----------------------------------------------------------------------------
class Test_UsuarioStreaming < Test::Unit::TestCase
    def setup
        @h1 = [{serie: "Juego de Tronos", minutos: 60}, {serie: "Breaking Bad", minutos: 40}]
        @h2 = [{serie: "The Office", minutos: 250}, {serie: "Fleabag", minutos: 250}]

        @usuario1 = UsuarioStreaming.new("Usuario1", :basico, @h1)
        @usuario2 = UsuarioStreaming.new("Usuario2", :premium, @h2)
    end

    def test_herencia
        assert(@usuario1.is_a?(Object))
        assert(@usuario2.is_a?(Object))
    end

    def test_plan
        assert(@usuario1.plan.is_a?(Symbol))
    end

    def test_comparable
        assert(@usuario1 < @usuario2)
    end

    def test_to_s
        assert_equal(@usuario1.to_s, "USER: Usuario1 (basico) - TOTAL VISTO: 100 min")
    end
end

# -----------------------------------------------------------------------------
# EJERCICIO EXTRA (NO PUNTUA)
# -----------------------------------------------------------------------------


class Aparcamiento
    attr_reader :plazas_totales, :coches_dentro

    def initialize(plazas_totales)
        @plazas_totales = plazas_totales
        @coches_dentro = 0
        @mutex = Mutex.new
        @cv = ConditionVariable.new
    end

    def entrar(matricula)
        @mutex.synchronize do
            while coches_dentro >= plazas_totales
                puts "<#{matricula}> Esperando para entrar ..."
                @cv.wait(@mutex)
            end

            @coches_dentro += 1
            puts "<#{matricula}> ha entrado. Plazas #{coches_dentro}/#{plazas_totales}"
        end
    end

    def salir(matricula)
        @mutex.synchronize do
            @coches_dentro -= 1
            puts "<#{matricula}> ha salido. Plazas #{coches_dentro}/#{plazas_totales}"
            @cv.signal
        end
    end
end

parking = Aparcamiento.new(3)

hilos = []

10.times do |i|
    sleep(rand(0.1..0.5))
    hilos << Thread.new do
        parking.entrar("000-00#{i}")
        sleep(rand(1..3))
        parking.salir("000-00#{i}")
    end
end

hilos.each(&:join)
