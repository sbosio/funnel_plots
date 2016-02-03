class ConjuntoDeUnidadesDeAnalisis < ActiveRecord::Base
  include UserStamp

  # Acl9: es un objeto autorizable
  acts_as_authorization_object subject_class_name: "Usuario", role_class_name: "PermisoDeUsuario"

  # Asociaciones
  belongs_to  :tipo_de_unidades_de_analisis
  belongs_to  :propietario, foreign_key: :created_user, class_name: "Usuario"
  has_many    :unidades_de_analisis, inverse_of: :conjunto_de_unidades_de_analisis
  has_many    :conjuntos_de_datos, inverse_of: :conjunto_de_unidades_de_analisis

  # Validaciones
  validates             :nombre, :tipo_de_unidades_de_analisis, presence: true
  validates             :nombre, uniqueness: { case_sensitive: false }
  validates_associated  :unidades_de_analisis, message: ""
  validate              :requiere_al_menos_dos_unidades

  # Modelo anidado: UnidadDeAnalisis
  accepts_nested_attributes_for :unidades_de_analisis, allow_destroy: true

  def requiere_al_menos_dos_unidades
    self.errors.add(:global, "^Debes definir como mínimo dos unidades de análisis") if self.unidades_de_analisis.size < 2
  end

  def descripcion_corta
    return nil unless descripcion.present?
    return descripcion if descripcion.length < 120
    descripcion[0..117] + "..."
  end

  # Método para indicar si este objeto puede modificarse
  # En el caso de los conjuntos de unidades de análisis, el nombre y descripción siempre se pueden
  # modificar, pero no el resto de los campos si ya fue utilizado en algún conjunto de datos
  def modificable?
    new_record? || conjuntos_de_datos.size == 0
  end

end
