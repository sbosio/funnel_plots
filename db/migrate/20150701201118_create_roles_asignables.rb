class CreateRolesAsignables < ActiveRecord::Migration
  def change
    create_table :roles_asignables do |t|
      t.string :codigo
      t.string :nombre
      t.boolean :global, :default => false
      t.timestamps null: false
    end

    load 'db/roles_asignables_seed.rb'
  end

end
