class DslQuirurgico

 elementos_validos = [
   "Sistema_anestesia_general", 
   "Monitor_multiparametro", 
   "Equipo_reanimacion", 
   "Ventilador_mecanico", 
   "Anestesia_local",
   "Monitor_simple"
 ]

 attr_reader :id, :tipo, :precio, :equipamiento, :salas, :personal

 def initialize(id, &block)
  @id = id
  @tipo = nil
  @precio = 0
  @equipamiento = []
  @salas = []
  @personal = []
  instance_eval(&block) if block_given?
 end

 def tipo(type)
   @tipo = type
 end

 def precio(price)
   @precio = price
 end

 def equipamiento(&block)
  instance_eval(&block)
 end
 
 elementos_validos.each do |nombre_metodo|
  define_method(nombre_metodo) do |num|
    @equipamiento << {elemento: nombre_metodo, numero: num}
  end
 end

 def quirofano(id, nombre:, estado:, tipo:, &block)
  aux = @personal
  @personal = []
  instance_eval(&block)
  salas << {id: id, nombre: nombre, estado: estado, tipo: tipo, lista_personal: @personal}
  @personal += aux
 end

 def personal(id, nombre:, turno:, especialidad:)
  @personal << {id: id, nombre: nombre, turno: turno, especialidad: especialidad}
 end


 def to_s
   salida = "Servicio Quirurgico: #{@id}\n"
   salida += ("=" * 53) + "\n\n"
   salida += "Tipo: #{@tipo}\n"
   salida += "Precio: #{@precio}€/h\n\n"
   salida += "Equipamiento:\n"
   @equipamiento.each do |elem|
    salida << " - #{elem[:elemento]} : #{elem[:numero]}\n"
   end
   salida << "\nSalas:\n"
   @salas.each do |quir|
     salida << " - Quirófano #{quir[:id]}, estado: #{quir[:estado]}, tipo: #{quir[:tipo]}"
     if quir[:lista_personal].empty?
      salida << "\n"
     else 
      salida << ", equipo: ("
      quir[:lista_personal].each do |person|
        case person[:especialidad]
        when :cirujano
          salida << "Dr. #{person[:nombre]}, "
        when :anestesista
          salida << "Enf. #{person[:nombre]}, "
        when :enfermero
          salida << "Enf. #{person[:nombre]}, "
        when :otro 
          salida << "Est. #{person[:nombre]}, "
        end
      end
      salida = salida[0..-3]
      salida << ")\n"
     end
    end
    salida << "\n"
    salida << "Personal:\n"
    @personal.each do |pers|
      case pers[:especialidad]
      when :cirujano
        space = (" " * 7)
        salida << " - Doctor      #{pers[:id]}, nombre: #{pers[:nombre]},#{space[0..-pers[:nombre].size]}turno: #{pers[:turno]}, especialidad: #{pers[:especialidad]}\n"
      when :anestesista
        space = (" " * 7)
        salida << " - Anestesista #{pers[:id]}, nombre: #{pers[:nombre]},#{space[0..-pers[:nombre].size]}turno: #{pers[:turno]}, especialidad: #{pers[:especialidad]}\n"
      when :enfermero
        space = (" " * 7)
        salida << " - Enfermería  #{pers[:id]}, nombre: #{pers[:nombre]},#{space[0..-pers[:nombre].size]}turno: #{pers[:turno]}, especialidad: #{pers[:especialidad]}\n"
      when :otro 
        space = (" " * 7)
        salida << " - Otros       #{pers[:id]}, nombre: #{pers[:nombre]},#{space[0..-pers[:nombre].size]}turno: #{pers[:turno]}, especialidad: #{pers[:especialidad]}\n"
      end
    end
    salida
  end
end




require 'rspec'

RSpec.describe "Prueba dsl" do
  before(:each) do
     @dsl = DslQuirurgico.new(20) do
        tipo "cirugia menor"
        precio 15.0

        equipamiento do
          Anestesia_local 1
          Monitor_simple  2
        end

        quirofano 102, nombre: "Q102", estado: :ocupado, tipo: "Clase A" do
          personal 3001, nombre: "Poo",    turno: :manana, especialidad: :cirujano
          personal 3002, nombre: "Struct", turno: :manana, especialidad: :anestesista
          personal 3003, nombre: "Tan",    turno: :tarde,  especialidad: :enfermero
          personal 3004, nombre: "Ni",     turno: :tarde,  especialidad: :otro
        end
      end
  end

  context "to_s" do
    it "1" do
    puts @dsl.to_s
    end
  end
end