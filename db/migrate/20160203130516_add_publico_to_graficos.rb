class AddPublicoToGraficos < ActiveRecord::Migration
  def change
    add_column :graficos, :publico, :boolean, default: false
  end
end
