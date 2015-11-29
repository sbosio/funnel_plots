class CreateDatos < ActiveRecord::Migration
  def change
    create_table :datos do |t|
      t.references  :conjunto_de_datos,           null: false,  index: true, foreign_key: true
      t.references  :unidad_de_analisis,          null: false,  index: true, foreign_key: true
      t.references  :categoria_de_la_covariable,  null: true,   index: true, foreign_key: true
      t.decimal     :valor,                       null: false,  length: 15, precision: 6
      t.integer     :created_user,                null: false
      t.integer     :updated_user,                null: false
      t.timestamps                                null: false
    end
    add_index       :datos, [:conjunto_de_datos_id, :unidad_de_analisis_id, :categoria_de_la_covariable_id],
                      name: "index_datos_unique_on_terna_de_unicidad", unique: true
    add_foreign_key :datos, :usuarios, column: :created_user
    add_foreign_key :datos, :usuarios, column: :updated_user
  end
end
