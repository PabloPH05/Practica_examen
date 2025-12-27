require 'thread'

class GestorArchivos
    def initialize
        @mutex = Mutex.new
        @condicion = ConditionVariable.new
        @escribiendo = false
        @lectores = 0
    end

    def leer(id)
        @mutex.synchronize do
            while(@escribiendo)
                @condicion.wait(@mutex)
            end

            puts "#{id} esta leyendo ..."
            @lectores += 1
        end
        sleep(rand(0.1..0.5))
        @mutex.synchronize do
            @lectores -= 1
            if (@lectores == 0)
                @condicion.broadcast
            end
        end
    end

    def escribir(id)
        @mutex.synchronize do
            while (@escribiendo || @lectores > 0)
                @condicion.wait(@mutex)
            end

            puts "#{id} esta escribiendo ..."
            @escribiendo = true
            sleep(1)
        end
        @mutex.synchronize do
            @escribiendo = false
            @condicion.broadcast
        end
    end
end

gestor = GestorArchivos.new
hilos = []

10.times do |i|
    tipo = rand < 0.2 ? :escritor : :lector
    hilos << Thread.new do
        sleep(rand(0.1..1))
        if tipo == :lector
            gestor.leer("Lector #{i}")
        else
            gestor.escribir("Escritor #{i}")
        end
    end
end

hilos.each(&:join)