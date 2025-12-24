require_relative 'html'

codigo1 = HTMLGenerator.new do
    h1 "Bienvenidos a mi Web"
    h2 "Esto es magia pura"
    p1  "Estoy aprendiendo a generar métodos dinámicamente."
    div "Contenido dentro de un div"
    article "Incluso etiquetas raras funcionan"
end

puts codigo1.codigo
