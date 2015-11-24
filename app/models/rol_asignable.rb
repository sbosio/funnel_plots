class RolAsignable < ActiveRecord::Base
  acts_as_authorization_object subject_class_name: "Usuario", role_class_name: "PermisoDeUsuario"

  has_and_belongs_to_many :permisos_de_usuario, join_table: "permisos_de_usuario_roles_asignables"
  has_and_belongs_to_many :usuarios_asociados, class_name: "Usuario", join_table: "roles_asignables_usuarios", inverse_of: :roles_asignados

  accepts_nested_attributes_for :permisos_de_usuario

  # Agregar un permiso a la definición del rol mediante un nombre de Permiso y un objeto
  # Se crea una instancia de PermisoDeUsuario nueva si no existe la combinación (Permiso, objeto)
  # Si el permiso no está asociado con el RolAsignable se añade y se iteran todos los usuarios que tienen
  # definido el rol, añadiendo el permiso correspondiente
  def agregar_permiso_de_usuario(nombre, objeto = nil)
    if objeto.nil?
      raise(ArgumentError, "Se pasó un único parámetro, y no es una instancia de 'PermisoDeUsuario'.") unless nombre.is_a? PermisoDeUsuario
      permiso_de_usuario = nombre
    else
      raise(ArgumentError, "No existe una instancia de 'Permiso' con 'codigo = #{nombre.to_s}'") unless Permiso.find_by(codigo: nombre.to_s).present?
      if objeto.instance_of? Symbol
        authorizable_type = objeto.to_s.classify
        authorizable_id = nil
      elsif objeto.instance_of? Class
        authorizable_type = objeto.to_s
        authorizable_id = nil
      else
        authorizable_type = objeto.class.to_s
        authorizable_id = objeto.id
      end
      raise(ArgumentError, "El modelo '#{authorizable_type}' no es un objeto autorizable. ¿Te olvidaste la sentencia 'acts_as_authorization_object' en la definición del modelo?") unless eval(authorizable_type).instance_methods.member?(:accepts_role?)
      permiso_de_usuario = PermisoDeUsuario.find_or_create_by(name: nombre.to_s, authorizable_type: authorizable_type, authorizable_id: authorizable_id)
    end

    # Asociar la instancia de PermisoDeUsuario a esta instancia de RolAsignable si todavía no está asociada
    unless self.permisos_de_usuario.member?(permiso_de_usuario)
      self.permisos_de_usuario << permiso_de_usuario

      # Como la instancia de RolAsignable fue modificada, iterar los usuarios agregando el permiso
      self.usuarios_asociados.each do |usuario|
        usuario.agregar_permiso_de_usuario(permiso_de_usuario)
      end
    end
  end

  # Eliminar un permiso a la definición del rol mediante un nombre de Permiso y un objeto
  # Si el permiso está asociado con el RolAsignable se elimina y se iteran todos los usuarios que tienen
  # definido el rol, eliminando el permiso correspondiente si no es otorgado por otro rol del mismo usuario
  def eliminar_permiso_de_usuario(nombre, objeto = nil)
    if objeto.nil?
      raise(ArgumentError, "Se pasó un único parámetro, y no es una instancia de 'PermisoDeUsuario'.") unless nombre.is_a? PermisoDeUsuario
      permiso_de_usuario = nombre
    else
      raise(ArgumentError, "No existe una instancia de 'Permiso' con 'codigo = #{nombre.to_s}'") unless Permiso.find_by(codigo: nombre.to_s).present?
      if objeto.instance_of? Symbol
        authorizable_type = objeto.to_s.classify
        authorizable_id = nil
      elsif objeto.instance_of? Class
        authorizable_type = objeto.to_s
        authorizable_id = nil
      else
        authorizable_type = objeto.class.to_s
        authorizable_id = objeto.id
      end
      permiso_de_usuario = PermisoDeUsuario.find_by(name: nombre.to_s, authorizable_type: authorizable_type, authorizable_id: authorizable_id)
    end
    return if permiso_de_usuario.nil?

    # Eliminar la instancia de PermisoDeUsuario de esta instancia de RolAsignable si está asociada
    if self.permisos_de_usuario.member?(permiso_de_usuario)
      self.permisos_de_usuario.delete(permiso_de_usuario)

      # Como la instancia de RolAsignable fue modificada, iterar los usuarios eliminando el permiso si no se los
      # otorga ningún otro rol
      self.usuarios_asociados.each do |usuario|
        usuario.eliminar_permiso_de_usuario(permiso_de_usuario) unless usuario.roles_asignados.any?{ |rol_asignado| rol_asignado.permisos_de_usuario.member?(permiso_de_usuario) }
      end
    end

  end

end