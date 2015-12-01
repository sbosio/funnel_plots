class CreateTiposDeEvaluacion < ActiveRecord::Migration
  def up
    create_table :tipos_de_evaluacion do |t|
      t.string  :nombre,                    null: false
      t.string  :codigo,                    null: false
      t.text    :descripcion
      t.string  :ruta_de_formulario
      t.string  :modelo_de_implementacion
    end

    load 'db/tipos_de_evaluacion_seed.rb'
  end

  def down
    drop_table :tipos_de_evaluacion
  end
end
