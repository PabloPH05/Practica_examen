module Videojuegos
    class Videojuego
        include Comparable

        attr_reader :titulo, :genero, :precio, :ventas

        def initialize (titulo, genero, precio, ventas)
            @titulo = titulo
            @genero = genero
            @precio = precio
            @ventas = ventas
        end

        def to_s
            "#{@titulo} (#{@genero.to_s}) - #{precio}€"
        end

        def recaudacion_total
            total_ventas = @ventas.sum { |venta| venta[:cantidad] }
            @precio * total_ventas
        end

        def <=>(other)
            if other.is_a? Videojuego
                if recaudacion_total == other.recaudacion_total
                    0
                elsif recaudacion_total < other.recaudacion_total
                    -1
                else
                    1
                end
            else
                nil
            end
        end
    end
end