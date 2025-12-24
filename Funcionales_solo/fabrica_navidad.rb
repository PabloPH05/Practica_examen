regalos = [
  { nombre: "PS5", precio: 500, destino: :tenerife, peso: 3.0 },
  { nombre: "Calcetines", precio: 10, destino: :madrid, peso: 0.1 },
  { nombre: "Bicicleta", precio: 200, destino: :tenerife, peso: 12.0 },
  { nombre: "Libro", precio: 20, destino: :madrid, peso: 0.5 },
  { nombre: "Carbón", precio: 0, destino: :tenerife, peso: 1.0 }
]

def regalos_para(destino, regalos)
    regalos_select = regalos.select{|y| y[:destino] == destino}.map{|x| x[:nombre]}
end

puts regalos_para(:madrid, regalos)

def precio_total(destino, regalos)
    precio_total = regalos.select{|x| x[:destino] == destino}.sum{|y| y[:precio]}
end

puts precio_total(:tenerife, regalos)

def mas_pesado(regalos)
    mas_pesado = regalos.max_by{|x| x[:peso]}
end

puts mas_pesado(regalos)