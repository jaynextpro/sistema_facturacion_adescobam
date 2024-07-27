class CreateInitialDb < ActiveRecord::Migration[7.1]
  def change
    create_table :clientes do |t|
      t.string :dui, null: false
      t.string :nombre_completo, null: false

      t.timestamps
    end

    create_table :medidores do |t|
      t.references :cliente
      t.string :medidor, null: false
      t.string :direccion
      t.string :sector, null: false
      t.boolean :activo, null: false, default: true

      t.timestamps
    end

    create_table :periodos do |t|
      t.integer :mes, null: false
      t.integer :año, null: false
      t.datetime :fecha_asamblea

      t.timestamps
    end 

    create_table :facturas do |t|
      t.references :medidor, null: false
      t.references :periodo, null: false
      t.references :cliente
      t.string :numero_factura, null: false
      t.date :fecha_emision, null: false
      t.decimal :lectura_anterior_metros_cubicos, null: false, scale: 2, precision: 30
      t.decimal :lectura_actual_metros_cubicos, null: false, scale: 2, precision: 30
      t.decimal :consumo_metros_cubicos, null: false, scale: 2, precision: 30
      t.decimal :valor_por_metro_cubico, null: false, scale: 2, precision: 30
      t.decimal :cargo_total, null: false, scale: 2, precision: 30
      t.decimal :cargo_total_facturas_pendientes, scale: 2, precision: 30
      t.decimal :cuota_social_pendiente, scale: 2, precision: 30
      t.date :fecha_vencimiento, null: false
      t.decimal :recargo_despues_vencimiento, null: false, scale: 2, precision: 30
      t.decimal :cargo_total_despues_vencimiento, null: false, scale: 2, precision: 30
      t.date :fecha_pago
      t.decimal :monto_total_pagado, scale: 2, precision: 30
      t.string :observaciones
      t.boolean :eliminada, default: false

      t.timestamps
    end
  end
end
