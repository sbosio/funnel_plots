class ConjuntoDeDatos < ActiveRecord::Base

  # Acl9: es un objeto autorizable
  acts_as_authorization_object subject_class_name: "Usuario", role_class_name: "PermisoDeUsuario"

end
