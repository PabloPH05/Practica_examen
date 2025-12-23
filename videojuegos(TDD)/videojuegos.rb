module Videojuegos
    class Videojuego

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
    end
end