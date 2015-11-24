class CreatePermisos < ActiveRecord::Migration
  def change
    create_table :permisos do |t|
      t.string :codigo
      t.string :nombre
    end

    load 'db/permisos_seed.rb'
  end
end
