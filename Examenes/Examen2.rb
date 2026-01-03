require 'test/unit'
require 'rspec'

class Jugador
    include Comparable
    attr_reader :nickname, :equipo, :region, :stats

    def initialize(nickname, equipo, region, stats = [])
        @nickname = nickname
        @equipo = equipo
        @region = region
        @stats = stats
    end

    def total_partidas
        stats.sum{|x| x[:partidas]}
    end

    def promedio
        if stats.size == 0
            return 0.0
        end
        (stats.sum{|x| x[:winrate]})/stats.size
    end

    def eficiencia
        total_partidas * promedio
    end

    def to_s
        "PLAYER: #{@nickname} [#{@equipo}], REGION: #{region}, DATA: #{total_partidas} games"
    end

    def <=>(otro)
        if otro.is_a?(Jugador)
            eficiencia <=> otro.eficiencia
        end
    end
end

# --------------------------------------------------------------------------

class Test_Jugador < Test::Unit::TestCase
    def setup
        @s1 = [{ partidas: 20, winrate: 50.0 }, { partidas: 10, winrate: 60.0 }] 
        @s2 = [{ partidas: 100, winrate: 40.0 }] 
        @s3 = [{ partidas: 5, winrate: 10.0 }] 

        @j1 = Jugador.new("Faker", :t1, "KR", @s1)
        @j2 = Jugador.new("Caps", :g2, "EU", @s2)
        @j3 = Jugador.new("Rookie", :ig, "CN", @s3)
    end

    def test_herencia
        assert(@j1.is_a?(Object))
        assert(@j1.is_a?(BasicObject))
    end

    def test_tipos
        assert(@j2.equipo.is_a?(Symbol))
        assert(@j3.stats.is_a?(Array))
    end

    def test_stats
        @j1.stats.each do |stat|
            assert(stat.is_a?(Hash))
            assert(stat[:winrate].is_a?(Float))
        end
    end

    def test_valid_team
        assert_includes([:t1, :g2, :fnatic, :ig], @j1.equipo)
    end

    def test_to_s
        str = @j1.to_s
        assert_match(/PLAYER: Faker/, str)
        assert_match(/DATA: 30 games/, str)
    end

    def test_comparable
        assert(@j1 < @j2)
        assert(@j1 > @j3)
    end
end

# --------------------------------------------------------------------------

def region_mas_activa(jugadores)
    region_counts = Hash.new(0)

    jugadores.each do |jugador|
        region_counts[jugador.region] += jugador.total_partidas
    end

    region_counts.max_by { |region, count| count }[0]
end

def buscar_prodigio(jugadores, equipo, min_winrate)
    jugadores_equipo = jugadores.select{|x| x.equipo == equipo}
    prodigios = jugadores_equipo.select do |j|
        j.stats.any? { |s| s[:winrate] > min_winrate }
    end
    prodigios.min_by { |j| j.total_partidas }
end

# --------------------------------------------------------------------------

RSpec.describe Jugador do
    before (:each) do
        @s1 = [{ partidas: 20, winrate: 50.0 }, { partidas: 10, winrate: 60.0 }] 
        @s2 = [{ partidas: 100, winrate: 40.0 }] 
        @s3 = [{ partidas: 5, winrate: 10.0 }] 

        @j1 = Jugador.new("Faker", :t1, "KR", @s1)
        @j2 = Jugador.new("Caps", :g2, "EU", @s2)
        @j3 = Jugador.new("Rookie", :ig, "CN", @s3)
    end

    context "Pruebas para region mas activa" do
        it "devuelve la region correcta" do
            expect(region_mas_activa([@j1,@j2,@j3])).to eq("EU")
        end
    end

    context "Pruebas para buscar_prodigio" do
        it "devuelve el jugador prodigio" do
            expect(buscar_prodigio([@j1,@j2,@j3], :t1, 55.0)).to eq(@j1)
        end

        it "devuelve nil si no hay jugador con winrate minimo" do
            expect(buscar_prodigio([@j1,@j2,@j3], :g2, 90.0)).to eq(nil)
        end

        it "devuelve nil si no existe jugador de dicho equipo" do
            expect(buscar_prodigio([@j1,@j2,@j3], :tsm, 70.0)).to eq(nil)
        end
    end
end

# --------------------------------------------------------------------------

class ServidorReplays
    attr_reader :cola_replays

    def initialize
        @cola_replays = []
        @mutex = Mutex.new
        @cv_nueva_replay = ConditionVariable.new
    end

    def subir_replay(nombre_archivo)
        @mutex.synchronize do
            puts "Nueva replay (#{nombre_archivo}) subida"
            @cola_replays << nombre_archivo
            @cv_nueva_replay.signal
        end
        sleep(0.5)
    end

    def procesar_replays
        @mutex.synchronize do
            while @cola_replays.empty? do
                puts "Esperando nuevas replays..."
                @cv_nueva_replay.wait(@mutex)
            end
            replay = @cola_replays.shift
            puts "Se ha procesado la replay: #{replay}"
        end
        sleep(0.5)
    end
end

servidor = ServidorReplays.new

hilo_servidor = Thread.new do
    loop do
        servidor.procesar_replays
    end
end

hilo_cliente = Thread.new do
    4.times do |i| 
        servidor.subir_replay("archivo #{i}.mp4")
        sleep(0.3)
    end
end

hilo_cliente.join
sleep(2)
hilo_servidor.kill

