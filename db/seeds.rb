# db/seeds.rb
require 'faker'
require 'date'

# Borrar datos previos
Factura.delete_all
Medidor.delete_all
Cliente.delete_all
Periodo.delete_all

puts "Datos previos borrados."

# Crear Clientes
10.times do
  Cliente.create!(
    dui: Faker::Number.number(digits: 9).to_s,
    nombre_completo: Faker::Name.name
  )
end

puts "Clientes creados."

# Crear Medidores
20.times do
  Medidor.create!(
    cliente: Cliente.order("RANDOM()").first,
    medidor: Faker::Number.unique.number(digits: 6).to_s,
    direccion: Faker::Address.full_address,
    sector: Faker::Address.community,
    activo: [true, false].sample
  )
end

puts "Medidores creados."

# Crear Periodos
(2023..2024).each do |year|
  (1..12).each do |month|
    Periodo.create!(
      mes: month,
      año: year,
      fecha_asamblea: Faker::Date.between(from: Date.new(year, month, 1), to: Date.new(year, month, -1))
    )
  end
end

puts "Periodos creados."

# Obtener todos los medidores y periodos
medidores = Medidor.all.to_a
periodos = Periodo.all.to_a

# Crear Facturas
50.times do |i|
  medidor = medidores.sample
  periodo = periodos.sample

  # Asegurarse de que no exista una factura con la misma combinación de medidor y periodo
  if Factura.exists?(medidor: medidor, periodo: periodo)
    puts "Factura #{i + 1}: ya existe una factura para el medidor #{medidor.medidor} y periodo #{periodo.mes}/#{periodo.año}."
    next
  end

  lectura_anterior = Faker::Number.decimal(l_digits: 2, r_digits: 2)
  lectura_actual = lectura_anterior + Faker::Number.decimal(l_digits: 1, r_digits: 2)
  valor_por_metro_cubico = Faker::Number.decimal(l_digits: 1, r_digits: 2)
  consumo = lectura_actual - lectura_anterior
  cargo_total = consumo * valor_por_metro_cubico
  recargo = cargo_total * 0.05
  cargo_total_pendientes = Faker::Number.decimal(l_digits: 2, r_digits: 2)
  cuota_social_pendiente = Faker::Number.decimal(l_digits: 2, r_digits: 2)
  cargo_total_despues_vencimiento = cargo_total + recargo + cargo_total_pendientes

  numero_factura = Factura.maximum(:numero_factura).to_i.next.to_s.rjust(4, '0')
  
  # Asegurarse de que el numero_factura sea único
  while Factura.exists?(numero_factura: numero_factura)
    numero_factura = Factura.maximum(:numero_factura).to_i.next.to_s.rjust(4, '0')
  end

  Factura.create!(
    medidor: medidor,
    periodo: periodo,
    cliente: medidor.cliente,
    numero_factura: numero_factura,
    fecha_emision: Faker::Date.backward(days: 30),
    lectura_anterior_metros_cubicos: lectura_anterior,
    lectura_actual_metros_cubicos: lectura_actual,
    consumo_metros_cubicos: consumo,
    valor_por_metro_cubico: valor_por_metro_cubico,
    cargo_total: cargo_total,
    cargo_total_facturas_pendientes: cargo_total_pendientes,
    cuota_social_pendiente: cuota_social_pendiente,
    fecha_vencimiento: Faker::Date.forward(days: 30),
    recargo_despues_vencimiento: recargo,
    cargo_total_despues_vencimiento: cargo_total_despues_vencimiento,
    fecha_pago: [nil, Faker::Date.backward(days: 15)].sample,
    monto_total_pagado: [nil, cargo_total_despues_vencimiento].sample,
    observaciones: Faker::Lorem.sentence,
    eliminada: [true, false].sample
  )

  puts "Factura #{i + 1}: creada con éxito para el medidor #{medidor.medidor} y periodo #{periodo.mes}/#{periodo.año}."
end

puts "Facturas creadas."
