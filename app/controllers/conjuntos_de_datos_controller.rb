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
      if conjunto_de_datos_parametros.has_key?("datos_attributes")
        render :tabla_de_datos
      else
        render :edit
      end
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

    if @conjunto_de_datos.datos.size == 0
      # No hay tabla de datos almacenada, construirla
      if @categorias.size > 0
        @unidades.each do |unidad|
          @categorias.each do |categoria|
            @conjunto_de_datos.datos.build(unidad_de_analisis_id: unidad.id, categoria_de_la_covariable_id: categoria.id)
          end
        end
      else
        @unidades.each do |unidad|
          @conjunto_de_datos.datos.build(unidad_de_analisis_id: unidad.id, categoria_de_la_covariable_id: nil)
        end
      end
    elsif @conjunto_de_datos.datos.size != (@unidades.size * (@categorias.size == 0 ? 1 : @categorias.size))
      # WTF???, la tabla de datos se debe haber corrompido
      raise Acl9::AccessDenied # TODO: cambiar esto por un método más inteligente
    end
  end

  private
    def establecer_conjunto_de_datos
      @conjunto_de_datos = ConjuntoDeDatos.find(params[:id])
      raise Acl9::AccessDenied if @conjunto_de_datos.propietario != usuario_actual

      @unidades = UnidadDeAnalisis.where(
          conjunto_de_unidades_de_analisis: @conjunto_de_datos.conjunto_de_unidades_de_analisis
        ).order(:id)
      @categorias = CategoriaDeLaCovariable.where(
          covariable: @conjunto_de_datos.covariable
        ).order(:id)
    end

    def conjunto_de_datos_parametros
      if @conjunto_de_datos.modificable?
        params.require(:conjunto_de_datos).permit(
            :nombre, :descripcion, :conjunto_de_unidades_de_analisis_id, :covariable_id,
            datos_attributes: [:id, :unidad_de_analisis_id, :categoria_de_la_covariable_id, :valor]
          )
      else
        params.require(:conjunto_de_datos).permit(:nombre, :descripcion,
            datos_attributes: [:id, :unidad_de_analisis_id, :categoria_de_la_covariable_id, :valor]
          )
      end
    end
end
