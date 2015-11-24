class PermisoDeUsuario < ActiveRecord::Base
  acts_as_authorization_role subject_class_name: "Usuario"

  # Validaciones (no se permiten roles 'globales')
  validates :name, presence: true
  validates :authorizable_type, presence: true
end