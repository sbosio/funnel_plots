class ConjuntoDeDatos < ActiveRecord::Base
  include UserStamp

  # Acl9: es un objeto autorizable
  acts_as_authorization_object subject_class_name: "Usuario", role_class_name: "PermisoDeUsuario"

  # Asociaciones
  belongs_to  :conjunto_de_unidades_de_analisis
  belongs_to  :covariable
  belongs_to  :propietario, foreign_key: :created_user, class_name: "Usuario"
  has_many    :datos, inverse_of: :conjunto_de_datos

  # Validaciones
  validates             :nombre, :conjunto_de_unidades_de_analisis, presence: true
  validates             :nombre, uniqueness: { case_sensitive: false }
  validates_associated  :datos, message: ""

  # Modelo anidado: Dato
  accepts_nested_attributes_for :datos, allow_destroy: false

  def descripcion_corta
    return descripcion if descripcion.length < 120
    descripcion[0..117] + "..."
  end

  # Método para indicar si este objeto puede modificarse
  # En el caso de los conjuntos de datos, el nombre, la descripción y todos sus datos asociados
  # pueden modificarse siempre, en cambio el conjunto de unidades de análisis y la covariable
  # no pueden modificarse una vez que se han cargado los datos.
  def modificable?
    new_record? || datos.size == 0
  end

end
