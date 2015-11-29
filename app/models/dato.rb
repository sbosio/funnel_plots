class Dato < ActiveRecord::Base
  include UserStamp

  # Asociaciones
  belongs_to  :conjunto_de_datos, inverse_of: :datos
  belongs_to  :unidad_de_analisis
  belongs_to  :categoria_de_la_covariable
  belongs_to  :propietario, foreign_key: :created_user, class_name: "Usuario"

  # Validaciones
  validates :conjunto_de_datos, :unidad_de_analisis, :valor, presence: true
  validates :valor, numericality: true, if: "valor.present?"
  validates :categoria_de_la_covariable, presence: true,
              if: "conjunto_de_datos.present? && conjunto_de_datos.covariable.present?"

end
