# See https://github.com/be9/acl9#configuration for details
#
Acl9.configure do |c|
  c.default_role_class_name = 'PermisoDeUsuario'
  c.default_subject_class_name = 'Usuario'
  c.default_subject_method     = "usuario_actual"
  c.default_association_name   = "permisos_de_usuario"
  c.default_join_table_name    = "permisos_de_usuario_usuarios"
  c.protect_global_roles       = true
  c.normalize_role_names       = true
end
