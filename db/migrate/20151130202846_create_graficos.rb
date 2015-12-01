class CreateGraficos < ActiveRecord::Migration
  def change
    create_table :graficos do |t|
      t.string      :nombre,                null: false
      t.text        :descripcion
      t.references  :tipo_de_evaluacion,    null: false, index: true, foreign_key: true
      t.references  :implementacion,        null: false, polymorphic: true, index: true
      t.string      :titulo
      t.string      :subtitulo
      t.string      :etiqueta_eje_x
      t.string      :etiqueta_eje_y
      t.integer     :created_user,          null: false
      t.integer     :updated_user,          null: false
      t.timestamps                          null: false
    end
    add_index       :graficos,              :created_user
    add_foreign_key :graficos,              :usuarios, column: :created_user
    add_foreign_key :graficos,              :usuarios, column: :updated_user
  end
end
