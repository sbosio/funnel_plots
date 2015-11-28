class CreatePermisosOtorgados < ActiveRecord::Migration
  def change
    create_table :permisos_otorgados do |t|
      t.references  :usuario,             index: true, foreign_key: true
      t.references  :permiso_de_usuario,  index: true, foreign_key: true
      t.integer     :created_user,        null: false
      t.integer     :updated_user,        null: false
      t.timestamps                        null: false
    end
    add_foreign_key :permisos_otorgados, :usuarios, column: :created_user
    add_foreign_key :permisos_otorgados, :usuarios, column: :updated_user
  end
end
