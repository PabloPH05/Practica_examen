require 'thread'

barra_vacia = true
num_plato = 0
mutex = Mutex.new
cv_cocinero = ConditionVariable.new
cv_camarero = ConditionVariable.new

hilo_cocinero = Thread.new do
    5.times do
        mutex.synchronize do
            #Hilo cocinero
            while !barra_vacia do
                puts "Esperando (cocinero)..."
                cv_cocinero.wait(mutex)
            end

            num_plato += 1
            puts "Cocinero pone plato #{num_plato} en la barra"
            barra_vacia = !barra_vacia

            cv_camarero.signal
        end
    end
end

hilo_camarero = Thread.new do
    5.times do

        mutex.synchronize do
            #Hilo camarero
            while barra_vacia do
                puts "Esperando (camarero)..."
                cv_camarero.wait(mutex)
            end

            puts "Recoge plato #{num_plato} de la barra"
            barra_vacia = !barra_vacia

            cv_cocinero.signal
        end
    end
end

hilo_cocinero.join
hilo_camarero.join

puts "Fin de la simulación"

