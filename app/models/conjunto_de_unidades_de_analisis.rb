class ConjuntoDeUnidadesDeAnalisis < ActiveRecord::Base
  include UserStamp

  # Acl9: es un objeto autorizable
  acts_as_authorization_object subject_class_name: "Usuario", role_class_name: "PermisoDeUsuario"

  # Asociaciones
  belongs_to  :tipo_de_unidades_de_analisis
  belongs_to  :propietario, foreign_key: :created_user, class_name: "Usuario"
  has_many    :unidades_de_analisis, inverse_of: :conjunto_de_unidades_de_analisis

  # Validaciones
  validates             :nombre, :tipo_de_unidades_de_analisis, presence: true
  validates             :nombre, uniqueness: { case_sensitive: false }
  validates_associated  :unidades_de_analisis

  # Modelo anidado: UnidadDeAnalisis
  accepts_nested_attributes_for :unidades_de_analisis, allow_destroy: true

  def descripcion_corta
    return descripcion if descripcion.length < 120
    descripcion[0..117] + "..."
  end

  # Métodos para indicar si este objeto puede modificarse
  # En el caso de los conjuntos de unidades de análisis, el nombre y descripción siempre se puede
  # modificar, pero no el resto de los campos si ya fue utilizado en algún gráfico
  def modificable?
    # TODO: modificar el método cuando agregue el modelo de Grafico
    new_record? || false
  end

end
