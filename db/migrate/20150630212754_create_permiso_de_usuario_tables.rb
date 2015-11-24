class CreatePermisoDeUsuarioTables < ActiveRecord::Migration

  def change
    create_table :permisos_de_usuario do |t|
      t.string   :name,                   null: false
      t.string   :authorizable_type,      null: true
      t.integer  :authorizable_id,        null: true
      t.boolean  :system, default: false, null: false
      t.timestamps                        null: false
    end

    add_index :permisos_de_usuario, :name
    add_index :permisos_de_usuario, [:authorizable_type, :authorizable_id], name: "idx_aa_tt_aa_id_on_pp_dd_uu"

    create_table :permisos_de_usuario_usuarios, id: false do |t|
      t.references  :usuario, null: false
      t.references  :permiso_de_usuario, null: false
    end

    add_index :permisos_de_usuario_usuarios, :usuario_id
    add_index :permisos_de_usuario_usuarios, :permiso_de_usuario_id
  end

end
