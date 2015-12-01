class CreateGraficosTad < ActiveRecord::Migration
  def change
    create_table :graficos_tad do |t|
      t.integer     :fuente_eventos_observados,   null: false
      t.integer     :fuente_poblacion,            null: false
      t.integer     :multiplicador
      t.integer     :created_user,                null: false
      t.integer     :updated_user,                null: false
      t.timestamps                                null: false
    end
    add_index       :graficos_tad, :created_user
    add_foreign_key :graficos_tad, :usuarios, column: :created_user
    add_foreign_key :graficos_tad, :usuarios, column: :updated_user    
    add_foreign_key :graficos_tad, :conjuntos_de_datos, column: :fuente_eventos_observados
    add_foreign_key :graficos_tad, :conjuntos_de_datos, column: :fuente_poblacion
  end
end
