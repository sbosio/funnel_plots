class CreateConjuntosDeUnidadesDeAnalisis < ActiveRecord::Migration
  def change
    create_table :conjuntos_de_unidades_de_analisis do |t|
      t.string      :nombre,                        null: false
      t.text        :descripcion
      t.references  :tipo_de_unidades_de_analisis,  index: false, foreign_key: true
      t.integer     :created_user,                  null: false
      t.integer     :updated_user,                  null: false
      t.timestamps                                  null: false
    end
    add_index       :conjuntos_de_unidades_de_analisis, :tipo_de_unidades_de_analisis_id,
                      name: "index_cua_on_tipo_de_unidades_de_analisis_id"
    add_foreign_key :conjuntos_de_unidades_de_analisis, :usuarios, column: :created_user
    add_foreign_key :conjuntos_de_unidades_de_analisis, :usuarios, column: :updated_user
  end
end
