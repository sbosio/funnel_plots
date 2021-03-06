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

  # Atributos no persistidos (para importación de datos externos)
  attr_accessor :datos_externos

  def descripcion_corta
    return nil unless descripcion.present?
    return descripcion if descripcion.length < 130
    descripcion[0..127] + "..."
  end

  # Método para indicar si este objeto puede modificarse
  # En el caso de los conjuntos de datos, el nombre, la descripción y todos sus datos asociados
  # pueden modificarse siempre, en cambio el conjunto de unidades de análisis y la covariable
  # no pueden modificarse una vez que se han cargado los datos.
  def modificable?
    new_record? || datos.size == 0
  end

  # Método para indicar si este objeto puede eliminarse
  # En el caso de los conjuntos de datos, pueden eliminarse mientras no se haya asociado a
  # nińgún gráfico.
  def eliminable?
    cuenta_de_graficos == 0
  end

end
