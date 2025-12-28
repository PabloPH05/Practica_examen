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

    def mejor_casa(caballeros)
        caballeros << self
        mejor_casa = caballeros.group_by{|i| i.casa}.map{|x,y| [x, y.map{|z| z.victorias}.sum]}.max_by{|a,b| b}[0]
        mejor_casa
    end
end
        
