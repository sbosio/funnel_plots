class AddCounterCacheCuentaDeGraficosToConjuntosDeDatos < ActiveRecord::Migration
  def change
    add_column :conjuntos_de_datos, :cuenta_de_graficos, :integer, default: 0, null: false
  end
end
