class CreateCategoriasDeLaCovariable < ActiveRecord::Migration
  def change
    create_table :categorias_de_la_covariable do |t|
      t.string      :nombre,        null: false
      t.text        :descripcion
      t.references  :covariable,    null: false, index: true, foreign_key: true
      t.integer     :created_user,  null: false
      t.integer     :updated_user,  null: false
      t.timestamps                  null: false
    end
    add_index       :categorias_de_la_covariable, :covariable_id,
                      name: "index_cdlc_on_covariable_id"
    add_index       :categorias_de_la_covariable, [:covariable_id, :nombre],
                      unique: true,
                      name: "index_unique_cdlc_on_covariable_id_and_nombre"
    add_foreign_key :categorias_de_la_covariable, :usuarios, column: :created_user
    add_foreign_key :categorias_de_la_covariable, :usuarios, column: :updated_user
  end
end
