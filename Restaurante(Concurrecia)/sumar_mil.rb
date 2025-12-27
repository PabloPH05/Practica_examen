require 'thread'

contador = 0

mutex = Mutex.new


hilo1 = Thread.new do
    1000.times do
        mutex.synchronize do
            contador += 1
        end
    end
end

hilo2 = Thread.new do
    1000.times do
        mutex.synchronize do
            contador += 1
        end
    end
end

hilo1.join
hilo2.join

puts "FINAL: #{contador}"