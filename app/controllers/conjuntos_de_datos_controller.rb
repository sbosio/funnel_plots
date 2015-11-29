class ConjuntosDeDatosController < ApplicationController
  before_action :autenticar_usuario!
  before_action :establecer_conjunto_de_datos, only: [:show, :edit, :update, :destroy, :tabla_de_datos]

  access_control do
    # TODO: Revisar los controles de acceso. Por ahora solo verificamos propiedad en las distintas acciones
    allow all
  end

  # GET /conjuntos_de_datos
  def index
    @conjuntos_de_datos = ConjuntoDeDatos.includes(
        :conjunto_de_unidades_de_analisis, :covariable
      ).where(propietario: usuario_actual)
  end

  # GET /conjuntos_de_datos/1
  def show
  end

  # GET /conjuntos_de_datos/new
  def new
    @conjunto_de_datos = ConjuntoDeDatos.new
  end

  # GET /conjuntos_de_datos/1/edit
  def edit
  end

  # POST /conjuntos_de_datos
  def create
    @conjunto_de_datos = ConjuntoDeDatos.new
    @conjunto_de_datos.attributes = conjunto_de_datos_parametros

    if @conjunto_de_datos.save
      redirect_to @conjunto_de_datos, notice: 'El conjunto de datos se creó correctamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /conjuntos_de_datos/1
  def update
    if @conjunto_de_datos.update(conjunto_de_datos_parametros)
      redirect_to @conjunto_de_datos,
        notice: 'El conjunto de datos se modificó correctamente.'
    else
      render :edit
    end
  end

  # DELETE /conjuntos_de_datos/1
  def destroy
    raise Acl9::AccessDenied unless @conjunto_de_datos.modificable?

    @conjunto_de_datos.destroy
    redirect_to conjuntos_de_datos_url,
      notice: 'Se eliminó correctamente el conjunto de unidades de análisis.'
  end

  def tabla_de_datos
  end

  private
    def establecer_conjunto_de_datos
      @conjunto_de_datos = ConjuntoDeDatos.find(params[:id])
      raise Acl9::AccessDenied if @conjunto_de_datos.propietario != usuario_actual
    end

    def conjunto_de_datos_parametros
      if @conjunto_de_datos.modificable?
        params.require(:conjunto_de_datos).permit(
            :nombre, :descripcion, :conjunto_de_unidades_de_analisis_id, :covariable_id
          )
      else
        params.require(:conjunto_de_datos).permit(:nombre, :descripcion)
#        params.require(:conjunto_de_datos).permit(
#          :nombre, :descripcion, datos_attributes: [:id, :nombre, :descripcion])
      end
    end
end
