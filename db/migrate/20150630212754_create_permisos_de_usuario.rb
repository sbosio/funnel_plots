class CreatePermisosDeUsuario < ActiveRecord::Migration

  def change
    create_table :permisos_de_usuario do |t|
      t.string      :name,              null: false
      t.string      :authorizable_type, null: false
      t.integer     :authorizable_id,   null: true
      t.boolean     :system,            null: false, default: false
      t.integer     :created_user,      null: false
      t.integer     :updated_user,      null: false
      t.timestamps                      null: false
    end
    add_index :permisos_de_usuario, :name
    add_index :permisos_de_usuario, [:authorizable_type, :authorizable_id], name: "index_pdu_on_authorizable"
    add_foreign_key :permisos_de_usuario, :usuarios, column: :created_user
    add_foreign_key :permisos_de_usuario, :usuarios, column: :updated_user
  end

end
