class AClass
    def a_method(a_block)
        @hello = "I say"
        puts "[ In AClass.a_method ] "
        puts "in #{self} object of class #{self.class}, @hello = #{@hello}"
        puts "[ In AClass.a_method ] when block is called... "
        a_block.call
    end

    def to_s
        "an AClass instance"
    end
end


a_clousure = lambda {
    @hello << " append!"
    puts "in #{self} object of class #{self.class}, @hello = #{@hello}"
}

def a_method(a_clousure)
    @hello = "hello"
    a_clousure.call
end

a_method(a_clousure)
data = AClass.new
data.a_method(a_clousure)
data2 = AClass.new
data2.a_method(a_clousure)


def compose(f, g)
    lambda { |x| f.call(g.call(x)) }
end
# 1. Definimos las tareas
poner_zapato = lambda { |x| x + " con zapato" }
atar_cordones = lambda { |x| x + " y atado" }

# 2. Creamos la función compuesta (primero zapato, luego cordones)
# Ojo al orden: compose(ULTIMA, PRIMERA) -> f(g(x))
vestirse_pies = compose(atar_cordones, poner_zapato)

# 3. Probamos
puts vestirse_pies.call("Pie izquierdo") 
# Salida: "Pie izquierdo con zapato y atado"
