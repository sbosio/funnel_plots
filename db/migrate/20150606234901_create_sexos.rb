class CreateSexos < ActiveRecord::Migration

  def up
    create_table :sexos do |t|
      t.string :nombre
      t.string :codigo
    end

    load 'db/sexos_seed.rb'
  end

  def down
    drop_table :sexos
  end

end
