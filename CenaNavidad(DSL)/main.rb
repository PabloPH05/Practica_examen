require_relative 'menu'

cena_navidad = Menu.new do
    entrante "Sopa de marisco", 5.50
    plato "Pavo relleno", 12.00
    postre "Tarta de Navidad", 4.00
    bebida "Vino tinto", 6.00
end

puts cena_navidad.ticket