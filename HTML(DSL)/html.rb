class HTMLGenerator
    def initialize(&block)
        @items = []
        instance_eval(&block) if block_given?
    end

    #htmls[:h1, :h2, :p1, :div]

    # htmls.each do |nombre_metodo|
    #     define_method(nombre_metodo) do |content|
    #         @items << {tag: nombre_metodo, content: content}
    #     end
    # end

    def method_missing(m, *args, &block)
        @items << {tag: m, content: args[0]}
    end

    def codigo
        salida = "--- CODIGO ---\n"
        salida += @items.map{|x| "<#{x[:tag]}> #{x[:content]} </#{x[:tag]}>"}.join("\n")
        salida
    end
end