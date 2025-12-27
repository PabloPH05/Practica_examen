require 'thread'

class Puente
    def initialize
        @coches = 0
        @sentido_actual = nil
        @mutex = Mutex.new
        @condicion = ConditionVariable.new
    end

    def entrar(id, sentido)
        @mutex.synchronize do
            while (@coches >= 3 || (sentido != @sentido_actual && @sentido_actual != nil)) do
                puts "Coche #{id} (#{sentido}) esperando para entrar"
                @condicion.wait(@mutex)
            end

            @coches += 1
            @sentido_actual = sentido
            puts "El coche #{id} con sentido #{sentido} ENTRA al puente. Total de coches: #{@coches}"
        end
    end

    def salir(id, sentido)
        @mutex.synchronize do
            @coches -= 1
            if (@coches == 0) 
                @sentido_actual = nil
            end
            puts "El coche #{id} con sentido #{sentido} SALE del puente. Total de coches: #{@coches}"
            @condicion.broadcast
        end
    end
end


puente = Puente.new

hilos = []
10.times do |i|
    sentido = [:norte, :sur].sample
    hilos << Thread.new do
        sleep(rand(0.1..0.5)) # Llegan en momentos distintos
        puente.entrar(i, sentido)
        sleep(0.5)
        puente.salir(i, sentido)
    end
end

hilos.each(&:join)

