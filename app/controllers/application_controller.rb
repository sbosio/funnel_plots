class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from 'Acl9::AccessDenied', with: :acceso_denegado
  rescue_from 'ActionController::ParameterMissing', with: :peticion_invalida

  before_action :configurar_parametros_permitidos, if: :devise_controller?
  before_action :set_user_stamp

  helper :all
  helper_method :usuario_actual, :usuario_autenticado?

  # Métodos para que el spanglish de mezclar nombres de modelos en español con Devise
  # no nos lastimen los ojos.
  def autenticar_usuario!
    authenticate_usuario!
  end

  def usuario_autenticado?
    usuario_signed_in?
  end

  def usuario_actual
    current_usuario
  end

  def sesion_del_usuario
    usuario_session
  end

  protected

  def configurar_parametros_permitidos
    devise_parameter_sanitizer.for(:sign_up) << [:nombre, :apellido, :sexo_id]
    devise_parameter_sanitizer.for(:account_update) << [:nombre, :apellido, :sexo_id]
  end

  private

  def acceso_denegado
    if usuario_actual.present?
      render template: 'shared/acceso_denegado'
    else
      # Esto es por seguridad, para el caso en que nos olvidamos de poner en un controlador
      # la sentencia 'before_action :autenticar_usuario!', pero no debería ejecutarse nunca.
      # Si al testear vemos este mensaje, hay que corregir el controlador.
      flash[:error] = 'Acceso denegado. No has iniciado una sesión.'
      redirect_to new_usuario_session_path
    end
  end

  def peticion_invalida
    render template: 'shared/peticion_invalida', status: :bad_request
  end    

end
