class CreateTiposDeUnidadesDeAnalisis < ActiveRecord::Migration
  def up
    create_table :tipos_de_unidades_de_analisis do |t|
      t.string :nombre
      t.text        :descripcion
    end
    load 'db/tipos_de_unidades_de_analisis_seed.rb'
  end

  def down
    drop_table :tipos_de_unidades_de_analisis
  end
end
