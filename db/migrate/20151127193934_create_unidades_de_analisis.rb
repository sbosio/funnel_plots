class CreateUnidadesDeAnalisis < ActiveRecord::Migration
  def change
    create_table :unidades_de_analisis do |t|
      t.string      :nombre,                            null: false
      t.text        :descripcion
      t.references  :conjunto_de_unidades_de_analisis,  index: false, foreign_key: true
      t.integer     :created_user,                      null: false
      t.integer     :updated_user,                      null: false
      t.timestamps                                      null: false
    end
    add_index       :unidades_de_analisis, :conjunto_de_unidades_de_analisis_id,
                      name: "index_uda_on_conjunto_de_unidades_de_analisis_id"
    add_index       :unidades_de_analisis, [:conjunto_de_unidades_de_analisis_id, :nombre],
                      unique: true,
                      name: "index_unique_uda_on_cduda_id_and_nombre"
    add_foreign_key :unidades_de_analisis, :usuarios, column: :created_user
    add_foreign_key :unidades_de_analisis, :usuarios, column: :updated_user
  end
end
