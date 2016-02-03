class CovariablesController < ApplicationController
  before_action :autenticar_usuario!
  before_action :establecer_covariable, only: [:show, :edit, :update, :destroy]

  access_control do
    # TODO: Revisar los controles de acceso. Por ahora solo verificamos propiedad en las distintas acciones
    allow all
  end

  # GET /covariables
  def index
    @covariables = Covariable.includes(:categorias_de_la_covariable).where(propietario: usuario_actual)
  end

  # GET /covariables/1
  def show
  end

  # GET /covariables/new
  def new
    @covariable = Covariable.new
  end

  # GET /covariables/1/edit
  def edit
  end

  # POST /covariables
  def create
    @covariable = Covariable.new
    @covariable.attributes = covariable_parametros

    if @covariable.save
      redirect_to @covariable, notice: 'La covariable se creó correctamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /covariables/1
  def update
    raise Acl9::AccessDenied unless @covariable.modificable?

    if @covariable.update(covariable_parametros)
      redirect_to @covariable,
        notice: 'La covariable se modificó correctamente.'
    else
      render :edit
    end
  end

  # DELETE /covariables/1
  def destroy
    raise Acl9::AccessDenied unless @covariable.modificable?
    @covariable.categorias_de_la_covariable.delete_all
    @covariable.destroy
    redirect_to covariables_path, notice: 'Se eliminó correctamente la covariable.'
  end

  private
    def establecer_covariable
      @covariable = Covariable.find(params[:id])
      raise Acl9::AccessDenied if @covariable.propietario != usuario_actual
    end

    def covariable_parametros
      if @covariable.modificable?
        params.require(:covariable).permit(
          :nombre, :descripcion, categorias_de_la_covariable_attributes: [:id, :nombre, :descripcion, :_destroy])
      else
        params.require(:covariable).permit(
          :nombre, :descripcion, categorias_de_la_covariable_attributes: [:id, :nombre, :descripcion])
      end
    end
end
