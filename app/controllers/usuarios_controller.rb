class UsuariosController < Devise::RegistrationsController
  before_action :autenticar_usuario!, except: [:new, :create]
  before_action :establecer_usuario, only: [:admin_edit, :admin_update, :admin_destroy]

  access_control do
    allow "administrar", on: Usuario
    allow "ver", on: Usuario, only: [:index]
    allow logged_in, only: [:edit, :update]
    allow anonymous, only: [:new, :create]
  end

  # GET /usuarios
  def index
    @usuarios = Usuario.no_eliminados.includes([:unidades_de_gestion, :sexo, :roles_asignados]).order(:id)
  end

  # GET /usuarios/sign_up
  def new
    super
  end

  # POST /usuarios
  def create
    super
  end

  # GET /usuarios/edit
  def edit
    super
  end

  # PUT /usuarios
  def update
    super
  end

  # GET /usuarios/:id/edit
  def admin_edit
    raise Acl9::AccessDenied if @usuario.id == 1
  end

  # POST /usuarios/:id
  def admin_update

    raise Acl9::AccessDenied if @usuario.id == 1

    # Obtener las modificaciones solicitadas en el formulario.
    roles_solicitados = params[:usuario].delete(:rol_asignados_ids).reject(&:blank?).map(&:to_i)

    # Calcular las instancias de RolAsignable que deben agregarse o eliminarse.
    agregar_roles = roles_solicitados - @usuario.rol_asignados_ids
    eliminar_roles = @usuario.rol_asignados_ids - roles_solicitados

    # Agregar los roles faltantes
    agregar_roles.each do |rol_asignable_id|
      @usuario.agregar_rol_asignable(RolAsignable.find(rol_asignable_id))
    end

    # Quitar los roles eliminados
    eliminar_roles.each do |rol_asignable_id|
      @usuario.eliminar_rol_asignable(RolAsignable.find(rol_asignable_id))
    end

    flash[:notice] = "Las modificaciones solicitadas se guardaron correctamente."
    redirect_to edit_usuario_path(@usuario)
  end

  # DELETE /usuarios/:id
  def admin_destroy
    raise Acl9::AccessDenied if @usuario.id == 1
    @usuario.update_attributes(cuenta_eliminada: true)
    redirect_to usuarios_path
  end

  private

  def establecer_usuario
    @usuario = Usuario.no_eliminados.find(params[:id])
  end

  def parametros_permitidos_admin
    params.require(:usuario).permit(rol_asignados_ids: [])
  end
end
