module ApplicationHelper
  
  # 
  # Devuelve una clase si el controlador especificado se corresponda con la pagina actual
  # @param controlador [ActionController::Base] El controlador de la pagina relacionada
  # 
  # @return String  La clase activa o un string vacio
  def nav_bar_activo?(controlador)
    if controller_name == controlador 
      return "active"
    else
      return ""
    end
  end

end
