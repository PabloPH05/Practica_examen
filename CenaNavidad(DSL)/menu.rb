class Menu
    attr_reader :items

    def initialize(&block)
        @items = []
        instance_eval(&block) if block_given?
    end

    # def entrante(nombre, precio)
    #     @items << {nombre: nombre, precio: precio, tipo: :entrante}
    # end

    # def plato(nombre, precio)
    #     @items << {nombre: nombre, precio: precio, tipo: :plato_principal}
    # end

    # def postre(nombre, precio)
    #     @items << {nombre: nombre, precio: precio, tipo: :postre}
    # end

    # def bebida(nombre, precio)
    #     @items << {nombre: nombre, precio: precio, tipo: :bebida}
    # end

    [:entrante, :plato, :postre, :bebida].each do |nombre_metodo|
        define_method(nombre_metodo) do |nombre, precio|
            @items << {nombre: nombre, precio: precio, tipo: nombre_metodo}
        end
    end

    def ticket
        salida = "--- TICKET CENA ---\n"
        salida += @items.map{|x| "#{x[:nombre]}: #{x[:precio]}€"}.join("\n")
        salida += "\n-------------------\nTOTAL = " + @items.sum{|x| x[:precio]}.to_s + "€"
    end
end