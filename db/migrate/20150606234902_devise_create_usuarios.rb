class DeviseCreateUsuarios < ActiveRecord::Migration

  def change
    create_table(:usuarios) do |t|
      t.string :nombre, null: false, default: ""
      t.string :apellido, null: false, default: ""
      t.references :sexo, foreign_key: true
      ## Devise
      t.string   :email,              null: false, default: ""
      t.string   :encrypted_password, null: false, default: ""
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email
      t.integer  :failed_attempts, default: 0, null: false
      t.string   :unlock_token
      t.datetime :locked_at
      t.boolean  :cuenta_eliminada, default: false
      t.timestamps null: false
    end

    add_index :usuarios, :email,                unique: true
    add_index :usuarios, :reset_password_token, unique: true
    add_index :usuarios, :confirmation_token,   unique: true
    add_index :usuarios, :unlock_token,         unique: true

    load 'db/usuarios_seed.rb'
  end

end
