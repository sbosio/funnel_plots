class SesionesController < Devise::SessionsController
  before_action :autenticar_usuario!, except: [:new, :create]

  # GET /usuarios/sign_in
  def new
    super
  end

  # POST /usuarios/sign_in
  def create
    # Según código de Devise 3.5.1
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)

    # Inicializaciones propias
    if usuario_actual.cuenta_eliminada
      sign_out(resource)
      set_flash_message(:error, :account_deleted)
      redirect_to root_url
      return
    #elsif usuario_actual.roles_asignados.size == 0
    #  set_flash_message(:error, :signed_in_but_no_role) if is_flashing_format?
    else
      set_flash_message(:notice, :signed_in) if is_flashing_format?
    end

    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  # DELETE /usuarios/sign_out
  def destroy
    super
  end

end
