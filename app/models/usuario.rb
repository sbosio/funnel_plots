class Usuario < ActiveRecord::Base
  acts_as_authorization_subject role_class_name: "PermisoDeUsuario"
  acts_as_authorization_object subject_class_name: "Usuario", role_class_name: "PermisoDeUsuario"

  # Include default devise modules. Others available are:
  # :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable,
         :timeoutable, :lockable, :confirmable

  # Asociaciones
  belongs_to :sexo
  has_and_belongs_to_many :roles_asignados, class_name: "RolAsignable", join_table: "roles_asignables_usuarios"

  # Atributo virtual para seleccionar una UGSP cuando es necesario
  attr_accessor :unidad_de_gestion_id

  # Usuarios asignados a tareas
  has_many :asignaciones_como_supervisor, class_name: "TareaDeAuditoria", foreign_key: 'supervisor_id'
  has_many :asignaciones_como_auditor, class_name: "TareaDeAuditoria", foreign_key: 'auditor_id'

  def self.no_eliminados
    self.where(cuenta_eliminada: false)
  end

  def self.por_rol(rol)
    return false unless (rol.class == RolAsignable and rol.present?)
    joins( :roles_asignados ).where(roles_asignables: {codigo: rol.codigo} )
  end

  def agregar_rol_asignable(rol)
    if rol.is_a? RolAsignable
      rol_asignable = rol
    else
      raise(ArgumentError, "No existe ninǵuna instancia de RolAsignable con 'codigo = #{rol.to_s}'") if (rol_asignable = RolAsignable.find_by(codigo: rol.to_s)).nil?
    end

    unless self.roles_asignados.member?(rol_asignable)
      self.roles_asignados << rol_asignable
      rol_asignable.permisos_de_usuario.each do |permiso_de_usuario|
        self.agregar_permiso_de_usuario(permiso_de_usuario)
      end
    end
  end

  def eliminar_rol_asignable(rol)
    if rol.is_a? RolAsignable
      rol_asignable = rol
    else
      raise(ArgumentError, "No existe ninǵuna instancia de RolAsignable con 'codigo = #{rol.to_s}'") if (rol_asignable = RolAsignable.find_by(codigo: rol.to_s)).nil?
    end

    if self.roles_asignados.member?(rol_asignable)
      self.roles_asignados.delete(rol_asignable)
      # Solo eliminamos los permisos otorgados únicamente por este rol que se elimina
      permisos_a_eliminar = rol_asignable.permisos_de_usuario.to_a
      self.roles_asignados.each do |rol_asignado|
        rol_asignado.permisos_de_usuario.each do |permiso_mantenido|
          permisos_a_eliminar.delete(permiso_mantenido)
        end
      end

      self.permisos_de_usuario.delete(permisos_a_eliminar) if permisos_a_eliminar.size > 0
    end
  end

  def agregar_permiso_de_usuario(permiso_de_usuario)
    raise(ArgumentError, "El parámetro no es una instancia de 'PermisoDeUsuario'") unless permiso_de_usuario.is_a?(PermisoDeUsuario)

    unless self.permisos_de_usuario.exists?(id: permiso_de_usuario.id)
      self.permisos_de_usuario << permiso_de_usuario
    end
  end

  def eliminar_permiso_de_usuario(permiso_de_usuario)
    raise(ArgumentError, "El parámetro no es una instancia de 'PermisoDeUsuario'") unless permiso_de_usuario.is_a?(PermisoDeUsuario)

    if self.permisos_de_usuario.exists?(id: permiso_de_usuario.id)
      self.permisos_de_usuario.delete(permiso_de_usuario)
    end
  end

  # Métodos útiles para la capa de presentación
  def nombre_y_apellido
    (nombre.to_s + " " + apellido.to_s).strip
  end

end
