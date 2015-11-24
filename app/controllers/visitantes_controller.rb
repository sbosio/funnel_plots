class VisitantesController < ApplicationController
  access_control do
    allow all
  end

  def index
    unless usuario_autenticado?
      redirect_to new_usuario_session_path
    end
  end
end
