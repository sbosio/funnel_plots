class CreateTiposDeEvaluacion < ActiveRecord::Migration
  def up
    create_table :tipos_de_evaluacion do |t|
      t.string :nombre
      t.text :descripcion
      t.boolean :implementado, default: false
    end

    load 'db/tipos_de_evaluacion_seed.rb'
  end

  def down
    drop_table :tipos_de_evaluacion
  end
end
