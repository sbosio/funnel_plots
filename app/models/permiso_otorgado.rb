class PermisoOtorgado < ActiveRecord::Base
  belongs_to :usuario
  belongs_to :permiso_de_usuario
end
