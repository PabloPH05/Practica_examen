class Caballero
    include Comparable
    attr_reader :nombre, :casa, :victorias, :fuerza

    def initialize(nombre, casa, victorias, fuerza)
        @nombre = nombre
        @casa = casa
        @victorias = victorias
        @fuerza = fuerza
    end

    def <=>(otro)
        if otro.is_a? Caballero
            victorias <=> otro.victorias
        else
            nil
        end
    end
end
        
