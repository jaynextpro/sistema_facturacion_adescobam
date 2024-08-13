class AddCanceladoToFacturas < ActiveRecord::Migration[7.1]
  def change
    add_column :facturas, :cancelado, :boolean, default: false, null: false
  end
end
