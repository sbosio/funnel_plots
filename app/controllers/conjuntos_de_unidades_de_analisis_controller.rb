class ConjuntosDeUnidadesDeAnalisisController < ApplicationController
  before_action :autenticar_usuario!
  before_action :establecer_conjunto_de_unidades_de_analisis, only: [:show, :edit, :update, :destroy]

  access_control do
    # TODO: Revisar los controles de acceso. Por ahora solo verificamos propiedad en las distintas acciones
    allow all
  end

  # GET /conjuntos_de_unidades_de_analisis
  def index
    @conjuntos_de_unidades_de_analisis = ConjuntoDeUnidadesDeAnalisis.includes(:unidades_de_analisis, :tipo_de_unidades_de_analisis).where(propietario: usuario_actual)
  end

  # GET /conjuntos_de_unidades_de_analisis/1
  def show
  end

  # GET /conjuntos_de_unidades_de_analisis/new
  def new
    @conjunto_de_unidades_de_analisis = ConjuntoDeUnidadesDeAnalisis.new
  end

  # GET /conjuntos_de_unidades_de_analisis/1/edit
  def edit
  end

  # POST /conjuntos_de_unidades_de_analisis
  def create
    @conjunto_de_unidades_de_analisis = ConjuntoDeUnidadesDeAnalisis.new
    @conjunto_de_unidades_de_analisis.attributes = conjunto_de_unidades_de_analisis_parametros

    if @conjunto_de_unidades_de_analisis.save
      redirect_to @conjunto_de_unidades_de_analisis, notice: 'El conjunto de unidades de análisis se creó correctamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /conjuntos_de_unidades_de_analisis/1
  def update
    if @conjunto_de_unidades_de_analisis.update(conjunto_de_unidades_de_analisis_parametros)
      redirect_to @conjunto_de_unidades_de_analisis,
        notice: 'El conjunto de unidades de análisis se modificó correctamente.'
    else
      render :edit
    end
  end

  # DELETE /conjuntos_de_unidades_de_analisis/1
  def destroy
    raise Acl9::AccessDenied unless @conjunto_de_unidades_de_analisis.modificable?
    @conjunto_de_unidades_de_analisis.unidades_de_analisis.delete_all
    @conjunto_de_unidades_de_analisis.destroy
    redirect_to conjuntos_de_unidades_de_analisis_url, notice: 'Se eliminó correctamente el conjunto de unidades de análisis.'
  end

  private
    def establecer_conjunto_de_unidades_de_analisis
      @conjunto_de_unidades_de_analisis = ConjuntoDeUnidadesDeAnalisis.find(params[:id])
      raise Acl9::AccessDenied if @conjunto_de_unidades_de_analisis.propietario != usuario_actual
    end

    def conjunto_de_unidades_de_analisis_parametros
      if @conjunto_de_unidades_de_analisis.modificable?
        params.require(:conjunto_de_unidades_de_analisis).permit(
          :nombre, :descripcion, :tipo_de_unidades_de_analisis_id,
          unidades_de_analisis_attributes: [:id, :nombre, :descripcion, :_destroy])
      else
        params.require(:conjunto_de_unidades_de_analisis).permit(
          :nombre, :descripcion, unidades_de_analisis_attributes: [:id, :nombre, :descripcion])
      end
    end
end
