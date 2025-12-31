class A
    @@var_clase = 1
    def self.var_clase
        @@var_clase
    end
end

puts A.var_clase

class B < A
    @@var_clase = 2
end

puts A.var_clase
puts B.var_clase

class C < A
    @@var_clase = 3
end

puts C.var_clase
puts A.var_clase

puts A.class_variables.inspect
puts B.class_variables.inspect
puts C.class_variables.inspect

class A
    @value = 1
    def self.value
        @value
    end
end

puts A.value

class B < A
    @value = 2
end

puts A.value
puts B.value

class C < A; @value = 3; end

puts B.value
puts C.value


class Superclase
  def toto
    puts "1. Superclase#toto ha sido llamado."
    puts "2. Ahora llamando a 'intimo'..."
    intimo # Llama implícitamente a self.intimo
  end

  private

  def intimo
    puts ">> Este es el 'intimo' de la Superclase (Privado)"
  end
end

class Subclase < Superclase
  # Sobrescribimos el método, aunque el original era privado
  def intimo
    puts ">> ¡Sorpresa! Este es el 'intimo' de la Subclase"
  end
end

# Ejecución
# obj = Subclase.new
# obj.toto


class Padre
  def saludar(nombre = "Nadie")
    puts "Hola, #{nombre}"
  end
end

class Hija < Padre
  def saludar(nombre)
    # CASO 1: super (sin paréntesis)
    # Reenvía 'nombre' al padre automáticamente.
    super 
    
    # CASO 2: super() (con paréntesis)
    # No envía nada. El padre usa su valor por defecto "Nadie".
    super() 
  end
end

# Ejecución
# obj = Hija.new
# obj.saludar("Pepe")

class X
    C = 100

    def mostrar_constante
        puts C
    end
end

class Y < X
    C = 200
end

# Ejecución
# obj_x = X.new
# obj_y = Y.new

# obj_x.mostrar_constante
# obj_y.mostrar_constante

class Animal
    def initialize
        if self.class == Animal
            raise NotImplementedError, "No se puede instanciar la clase abstracta Animal"
        end
    end
    def hacer_sonido
        raise NotImplementedError, "Las subclases deben implementar hacer_sonido"
    end
end

class Perro < Animal
    def hacer_sonido
        puts "¡Guau!"
    end
end

# Ejecución
# animal = Animal.new
# animal.hacer_sonido

# perro = Perro.new
# perro.hacer_sonido

def show (a_class)
    if (a_class != nil) then
        puts "#{a_class}:: es hija de = #{a_class.superclass}"
        show(a_class.superclass)
    end
end
#show(Fixnum)

class AClass
    def m
        "method m"
    end
end
obj = AClass.new
def obj.s1
    "method s1"
end
class << obj
    def s2
        "method s2"
    end
end

# Ejecución
# puts obj.m
# puts obj.s1
# puts obj.s2

# obj2 = AClass.new
# puts obj2.m