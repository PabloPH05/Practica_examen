require 'thread'

class Fabrica
    def initialize
        @mutex = Mutex.new
        @cv = ConditionVariable.new

        @cabezas = 0
        @cuerpos = 0
    end

    def const_cabeza(id)
        @mutex.synchronize do
            while (@cabezas >= 5) do
                puts "El constructor #{id} esperando para construir una cabeza."
                @cv.wait(@mutex)
            end
            puts "El cosntructor #{id} construye una cabeza. Total cabezas: #{@cabezas + 1}"
            @cabezas += 1
        end
        sleep(0.5)
        @mutex.synchronize do
            @cv.broadcast
        end
    end

    def const_cuerpo(id)
        @mutex.synchronize do
            while (@cuerpos >= 5) do
                puts "El constructor #{id} esperando para construir un cuerpo."
                @cv.wait(@mutex)
            end
            puts "El constructor #{id} construye un cuerpo. Total cuerpos: #{@cuerpos + 1}"
            @cuerpos += 1
        end
        sleep(0.5)
        @mutex.synchronize do
            @cv.broadcast
        end
    end

    def ensamblar(id)
        @mutex.synchronize do
            while (@cuerpos == 0 || @cabezas == 0)
                puts "El ensamblador #{id} esperando para ensamblar un robot."
                @cv.wait(@mutex)
            end
            puts "El ensamblador #{id} crea un robot. Cuerpos: #{@cuerpos - 1}, Cabezas: #{@cabezas - 1}"
            @cuerpos -= 1
            @cabezas -= 1
        end
        sleep(1.5)
        @mutex.synchronize do
            @cv.broadcast
        end
    end
end

fabrica = Fabrica.new
hilos = []

50.times do |i|
    tipo = [:cabeza, :cuerpo, :ensamblador].sample
    hilos << Thread.new do
        sleep(rand(0.1..1))
        if tipo == :cabeza
            fabrica.const_cabeza(i)
        else
            if tipo == :cuerpo
                fabrica.const_cuerpo(i)
            else
                fabrica.ensamblar(i)
            end
        end
    end
end

hilos.each(&:join)



