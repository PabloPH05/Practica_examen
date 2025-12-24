class HTMLGenerator
    def initialize(&block)
        @items = []
        instance_eval(&block) if block_given?
    end

    [:h1, :h2, :div, :p].each do |nombre_metodo|
        define_method(nombre_metodo) do |content|
            @items << {tag: nombre_metodo, content: content}
        end
    end

    def codigo
        salida = "--- CODIGO ---\n"
        salida += @items.map{|x| "<#{x[:tag]}> #{x[:content]} </#{x[:tag]}>"}.join("\n")
        salida
    end
end