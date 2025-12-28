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

    def guardia_real(caballeros)
        caballeros << self
        los_mejores = caballeros.select{|i| i.fuerza > 8} #Filtrar
        ordenados = los_mejores.sort_by{|x| x.victorias} #Ordenar
        resultado = ordenados.map{|i| "#{i.nombre} (#{i.casa})"}
        resultado
    end
end
