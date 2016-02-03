class Grafico < ActiveRecord::Base
  include UserStamp

  # Acl9: es un objeto autorizable
  acts_as_authorization_object subject_class_name: "Usuario", role_class_name: "PermisoDeUsuario"

  # Asociaciones
  belongs_to  :tipo_de_evaluacion
  belongs_to  :implementacion, polymorphic: true, dependent: :destroy
  belongs_to  :propietario, foreign_key: :created_user, class_name: "Usuario"

  # Validaciones
  validates             :nombre, :tipo_de_evaluacion, :implementacion, presence: true
  validates             :nombre, uniqueness: { case_sensitive: false }
  validates_associated  :implementacion

  def descripcion_corta
    return nil unless descripcion.present?
    return descripcion if descripcion.length < 130
    descripcion[0..127] + "..."
  end

  # Método para indicar si este objeto puede modificarse
  # Los gráficos pueden modificarse siempre
  def modificable?
    true
  end

end
