class CreateConjuntosDeDatos < ActiveRecord::Migration
  def change
    create_table :conjuntos_de_datos do |t|
      t.string      :nombre,                            null: false
      t.text        :descripcion
      t.references  :conjunto_de_unidades_de_analisis,  null: false, index: false, foreign_key: true
      t.references  :covariable,                        null: true, index: true, foreign_key: true
      t.integer     :created_user,                      null: false
      t.integer     :updated_user,                      null: false
      t.timestamps                                      null: false
    end
    add_index       :conjuntos_de_datos, :conjunto_de_unidades_de_analisis_id,
                      name: "index_cdd_on_conjunto_de_unidades_de_analisis_id"
    add_foreign_key :conjuntos_de_datos, :usuarios, column: :created_user
    add_foreign_key :conjuntos_de_datos, :usuarios, column: :updated_user
  end
end
