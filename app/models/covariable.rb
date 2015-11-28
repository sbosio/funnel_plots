class Covariable < ActiveRecord::Base
  include UserStamp

  # Acl9: es un objeto autorizable
  acts_as_authorization_object subject_class_name: "Usuario", role_class_name: "PermisoDeUsuario"

  # Asociaciones
  belongs_to  :propietario, foreign_key: :created_user, class_name: "Usuario"
  has_many    :categorias_de_la_covariable, inverse_of: :covariable

  # Validaciones
  validates             :nombre, presence: true
  validates             :nombre, uniqueness: { case_sensitive: false }
  #validates_associated  :categorias_de_la_covariable, message: ""
  validate              :requiere_al_menos_dos_categorias

  # Modelo anidado: CategoriaDeLaCovariable
  accepts_nested_attributes_for :categorias_de_la_covariable, allow_destroy: true

  def requiere_al_menos_dos_categorias
    self.errors.add(:global, "^Debes definir como mínimo dos categorías") if self.categorias_de_la_covariable.size < 2
  end

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
