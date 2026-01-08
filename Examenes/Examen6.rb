# { id: String, divisa: Symbol, cantidad: Integer, tipo: :compra/:venta, riesgo: Float }
transacciones = [
    { id: "T001", divisa: :USD, cantidad: 1000, tipo: :compra, riesgo: 0.05 },
    { id: "T002", divisa: :EUR, cantidad: 500, tipo: :venta, riesgo: 0.03 },
    { id: "T003", divisa: :USD, cantidad: 750, tipo: :compra, riesgo: 0.07 },
    { id: "T004", divisa: :EUR, cantidad: 2000, tipo: :venta, riesgo: 0.04 },
    { id: "T005", divisa: :GBP, cantidad: 100000, tipo: :compra, riesgo: 0.06 },
    { id: "T006", divisa: :EUR, cantidad: 1200, tipo: :compra, riesgo: 0.02 },
    { id: "T007", divisa: :GBP, cantidad: 300, tipo: :venta, riesgo: 0.08 },
    { id: "T008", divisa: :USD, cantidad: 600, tipo: :venta, riesgo: 0.05 },
    { id: "T009", divisa: :GBP, cantidad: 1500, tipo: :compra, riesgo: 0.09 },
    { id: "T010", divisa: :EUR, cantidad: 2500, tipo: :compra, riesgo: 0.10 }
]

def resumen_mercado(transacciones)
    grupos_transacciones = transacciones.group_by{|x| x[:divisa]}
    grupos_transacciones.transform_values{|grupos| {volumen_total: grupos.sum{|n| n[:cantidad]},
                                                    riesgo_medio: grupos.sum{|n| n[:riesgo]}/grupos.size.to_f}}
end

def resumen_mercado_optimizado(transacciones)
    acumulado = transacciones.each_with_object({}) do |transaccion, hash|
        divisa = transaccion[:divisa]
        hash[divisa] ||= { volumen_total: 0, riesgo_total: 0.0, count: 0 }
        hash[divisa][:volumen_total] += transaccion[:cantidad]
        hash[divisa][:riesgo_total] += transaccion[:riesgo]
        hash[divisa][:count] += 1
    end

    acumulado.transform_values do |valores|
        {
            volumen_total: valores[:volumen_total],
            riesgo_medio: valores[:riesgo_total] / valores[:count].to_f
        }
    end
end

puts resumen_mercado(transacciones)
puts resumen_mercado_optimizado(transacciones)

# -------------------------------------------------------------------------------------------------

class MotorFraude
    attr_reader :nombre, :reglas

    def initialize(nombre, &block)
        @nombre = nombre
        @reglas = []

        instance_eval(&block) if block_given?
    end

    def bloquear_pais(pais)
        reglas << {tipo: :bloqueo_pais, pais: pais}
    end

    def cuando_monto_mayor(cantidad, &block)
        reglas << {tipo: :condicion, cantidad: cantidad}
        instance_eval(&block) if block_given?
    end

    def exigir(metodo)
        reglas << {tipo: :exigir, metodo: metodo}
    end

    def bloquear_tipo(tarjeta)
        reglas << {tipo: :bloqueo_tipo, tarjeta: tarjeta}
    end

    def to_s
        salida = "REGLAS: #{nombre}\n"
        reglas.each do |regla|
            case regla[:tipo]
            when :bloqueo_pais
                salida += "- Bloquear procedencia: #{regla[:pais]}\n"
            when :condicion
                salida += "- CONDICION (> #{regla[:cantidad]}): \n"
            when :exigir
                salida += "   * Exigir: #{regla[:metodo]}\n"
            when :bloqueo_tipo
                salida += "   * Bloquear tipo: #{regla[:tarjeta]}\n"
            end
        end
        salida
    end
end

filtro = MotorFraude.new("Reglas BlackFriday") do
  bloquear_pais :rusia
  bloquear_pais :corea_norte
  
  cuando_monto_mayor 1000 do
    exigir :sms
    bloquear_tipo :tarjeta_prepago
  end
  
  cuando_monto_mayor 5000 do
    exigir :llamada_banco
  end
end

puts filtro

# -----------------------------------------------------------------------------

class BufferBursatil
    attr_reader :capacidad, :buffer

    def initialize(capacidad)
        @capacidad = capacidad
        @buffer = []

        @mutex = Mutex.new
        @cv_productor = ConditionVariable.new
        @cv_consumidor = ConditionVariable.new
    end

    def producir(orden)
        @mutex.synchronize do
            while buffer.size == capacidad do
                @cv_productor.wait(@mutex)
            end

            buffer << orden
            puts "Nueva orden [#{orden}]. Buffer: #{buffer.size}/#{capacidad}."
        end
        @cv_consumidor.broadcast
        sleep(rand(0.1..0.5))
    end

    def consumir
        @mutex.synchronize do
            while buffer.empty? do
                @cv_consumidor.wait(@mutex)
            end

            orden = buffer.shift
            puts "Procesa orden [#{orden}]. Buffer: #{buffer.size}/#{capacidad}."
        end

        @cv_productor.broadcast
        sleep(rand(1..2))
    end
end

buffer = BufferBursatil.new(5)
hilos = []

2.times do |i|
  hilos << Thread.new do
    10.times do
      orden = "ORD-#{rand(1000..9999)}"
      buffer.producir(orden)
    end
  end
end

2.times do |i|
  hilos << Thread.new do
    10.times do
      buffer.consumir
    end
  end
end

hilos.each(&:join)

# -----------------------------------------------------------------------------

class AuditProxy
    attr_reader :objeto

    def initialize(objeto)
        @objeto = objeto
    end

    def method_missing(metodo, *argumentos)
        puts "Llamando a metodo [#{metodo}]"
        if objeto.respond_to?(metodo)
            objeto.send(metodo, *argumentos)
        else
            super
        end
    end

    def respond_to_missing?(method_name, include_private = false)
        @objeto.respond_to?(method_name) || super
    end
end

string_real = "hola mundo"

proxy = AuditProxy.new(string_real)

puts proxy.shift