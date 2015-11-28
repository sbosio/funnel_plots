class CategoriaDeLaCovariable < ActiveRecord::Base
  include UserStamp

  # Asociaciones
  belongs_to  :covariable
  belongs_to  :propietario, foreign_key: :created_user, class_name: "Usuario"

  # Validaciones
  validates :nombre, :covariable, presence: true
  validates :nombre,
              uniqueness: {
                scope: :covariable,
                case_sensitive: false,
                message: "ya fue utilizado en esta covariable"
              }

  def descripcion_corta
    return descripcion if descripcion.length < 130
    descripcion[0.127] + "..."
  end

  def modificable?
    true
  end
end
