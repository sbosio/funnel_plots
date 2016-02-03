class UnidadDeAnalisis < ActiveRecord::Base
  include UserStamp

  # Asociaciones
  belongs_to  :conjunto_de_unidades_de_analisis
  belongs_to  :propietario, foreign_key: :created_user, class_name: "Usuario"

  # Validaciones
  validates :nombre, :conjunto_de_unidades_de_analisis, presence: true
  validates :nombre,
              uniqueness: {
                scope: :conjunto_de_unidades_de_analisis,
                case_sensitive: false,
                message: "ya fue utilizado en este conjunto"
              }

  def descripcion_corta
    return nil unless descripcion.present?
    return descripcion if descripcion.length < 130
    descripcion[0.127] + "..."
  end

  def modificable?
    true
  end
end
