class CreateCovariables < ActiveRecord::Migration
  def change
    create_table :covariables do |t|
      t.string      :nombre,        null: false
      t.text        :descripcion
      t.integer     :created_user,  null: false
      t.integer     :updated_user,  null: false
      t.timestamps                  null: false
    end
    add_foreign_key :covariables, :usuarios, column: :created_user
    add_foreign_key :covariables, :usuarios, column: :updated_user
  end
end
