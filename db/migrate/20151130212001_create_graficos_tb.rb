class CreateGraficosTb < ActiveRecord::Migration
  def change
    create_table :graficos_tb do |t|
      t.integer     :fuente_eventos_observados,   null: false
      t.integer     :fuente_poblacion,            null: false
      t.integer     :multiplicador
      t.integer     :created_user,                null: false
      t.integer     :updated_user,                null: false
      t.timestamps                                null: false
    end
    add_index       :graficos_tb, :created_user
    add_foreign_key :graficos_tb, :usuarios, column: :created_user
    add_foreign_key :graficos_tb, :usuarios, column: :updated_user    
    add_foreign_key :graficos_tb, :conjuntos_de_datos, column: :fuente_eventos_observados
    add_foreign_key :graficos_tb, :conjuntos_de_datos, column: :fuente_poblacion
  end
end
