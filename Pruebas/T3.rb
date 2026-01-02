# Ejemplo de uso de hilos en Ruby
# print Thread.main
# print "\n"
# t1 = Thread.new {sleep 100}
# Thread.list.each {|thr| p thr }
# print "Current thread = " + Thread.current.to_s
# print "\n"
# t2 = Thread.new {sleep 100}
# Thread.list.each {|thr| p thr }
# print Thread.current
# print "\n"
# Thread.kill(t1)
# Thread.pass # pass execution to t2 now
# t3 = Thread.new do
# sleep 20
# Thread.exit # exit the thread
# end
# Thread.kill(t2) # now kill t2
# Thread.list.each {|thr| print thr }
# # now exit the main thread (killing any others)
# Thread.exit

# Ejemplo de variables de hilo en Ruby (con condición de carrera pero minima (en la practica no se ve))
# count = 0
# threads = []
# 10.times do |i|
# threads[i] = Thread.new do
# sleep(rand(0.1))
# Thread.current["mycount"] = count
# count += 1
# end
# end
# threads.each {|t| t.join; print t["mycount"], ", "}
# puts "count = #{count}"

# Ejemplo de variables de hilo en Ruby (con condición de carrera real)

# count = 0
# threads = []

# 10.times do |i|
#   threads[i] = Thread.new do
#     # En lugar de 1 vez, lo hacemos muchas veces para agotar el tiempo del hilo
#     100_000.times do 
#       val = count
#       # Forzamos un micro-cambio de contexto para simular mala suerte
#       # (aunque sin esto también fallaría con suficientes iteraciones)
#       sleep(0.000001) 
#       count = val + 1
#     end
#   end
# end

# threads.each(&:join)

# puts "Esperado: 1,000,000"
# puts "Real:     #{count}"

# Ejemplo de hilos secunciales en Ruby (con condición de carrera)

# def inc(n)
#     n + 1
# end
# sum = 0
# threads = (1..10).collect do
#         Thread.new do
#         10000.times do
#         sum = inc(sum)
#         end
#     end
# end
# threads.each(&:join)
# puts sum

# Ejemplo de hilos secunciales en Ruby (sin condición de carrera usando Mutex)

# def inc(n)
#     n + 1
# end
# mutex = Mutex.new
# sum = 0
# threads = (1..10).collect do
#     Thread.new do
#         10_000.times do
#             mutex.synchronize do
#                 sum = inc(sum)
#             end
#         end
#     end
# end
# threads.each(&:join)
# puts sum

# Ejemplo de uso de ConditionVariable en Ruby
mutex = Mutex.new
cv = ConditionVariable.new
a = Thread.new {
    mutex.synchronize {
        print "A: Esta en una region critica, esperando por cv\n"
        cv.wait(mutex)
        print "A: Esta en la region critica de nuevo!. Sigue\n"
    }
}
print "En medio\n"
b = Thread.new {
    mutex.synchronize {
        puts "B: Esta en la region critica pero tiene a cv"
        cv.signal
        puts "B: Esta en la region critica, Saliendo"
    }
}

a.join
b.join