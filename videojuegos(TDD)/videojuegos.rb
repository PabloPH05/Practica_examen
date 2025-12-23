module Videojuegos
    class Videojuego

        attr_reader :titulo, :genero, :precio, :ventas

        def initialize (titulo, genero, precio, ventas)
            @titulo = titulo
            @genero = genero
            @precio = precio
            @ventas = ventas
        end
    end
end