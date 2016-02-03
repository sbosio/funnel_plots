class GraficosController < ApplicationController
  before_action :autenticar_usuario!
  before_action :establecer_grafico, only: [:show, :edit, :update, :destroy]

  access_control do
    # TODO: Revisar los controles de acceso. Por ahora solo verificamos propiedad en las distintas acciones
    allow all
  end

  # GET /graficos
  def index
    @graficos = Grafico.includes(
        :implementacion, :tipo_de_evaluacion
      ).where(propietario: usuario_actual)
  end

  # GET /graficos/1
  def show
    @lazy_high_chart = @grafico.implementacion.obtener_grafico
  end

  # GET /graficos/new
  def new
    @grafico = Grafico.new
    @tipos_de_evaluacion = TipoDeEvaluacion.all.order(:nombre).map do |tipo|
        if tipo.ruta_de_formulario.present?
          [tipo.nombre, tipo.id, :'data-ruta' => tipo.ruta_de_formulario]
        else
          [tipo.nombre, tipo.id, disabled: true, title: "Aún no implementado"]
        end
      end
    @validar_implementacion = false
  end

  # GET /graficos/1/edit
  def edit
    raise Acl9::AccessDenied if @grafico.propietario != usuario_actual
    @tipos_de_evaluacion = TipoDeEvaluacion.all.order(:nombre).map do |tipo|
        if tipo.ruta_de_formulario.present?
          [tipo.nombre, tipo.id, :'data-ruta' => tipo.ruta_de_formulario]
        else
          [tipo.nombre, tipo.id, disabled: true, title: "Aún no implementado"]
        end
      end
    @validar_implementacion = false
  end

  # POST /graficos
  def create
    @grafico = Grafico.new
    @grafico.attributes = grafico_parametros
    if @grafico.tipo_de_evaluacion.present?
      modelo = @grafico.tipo_de_evaluacion.modelo_de_implementacion
      @grafico.implementacion = Object.const_get(modelo).new(implementacion_parametros(modelo))
    end

    if @grafico.save
      redirect_to @grafico, notice: 'El gráfico se creó correctamente.'
    else
      @tipos_de_evaluacion = TipoDeEvaluacion.all.order(:nombre).map do |tipo|
          if tipo.ruta_de_formulario.present?
            [tipo.nombre, tipo.id, :'data-ruta' => tipo.ruta_de_formulario]
          else
            [tipo.nombre, tipo.id, disabled: true, title: "Aún no implementado"]
          end
        end
      @validar_implementacion = true
      render :new
    end
  end

  # PATCH/PUT /graficos/1
  def update
    @grafico.attributes = grafico_parametros
    if @grafico.tipo_de_evaluacion.present?
      modelo = @grafico.tipo_de_evaluacion.modelo_de_implementacion
      @grafico.implementacion.attributes = implementacion_parametros(modelo)
    end

    if @grafico.save
      @grafico.implementacion.save
      redirect_to @grafico,
        notice: 'El gráfico se modificó correctamente.'
    else
      @tipos_de_evaluacion = TipoDeEvaluacion.all.order(:nombre).map do |tipo|
          if tipo.ruta_de_formulario.present?
            [tipo.nombre, tipo.id, :'data-ruta' => tipo.ruta_de_formulario]
          else
            [tipo.nombre, tipo.id, disabled: true, title: "Aún no implementado"]
          end
        end
      @validar_implementacion = true
      render :edit
    end
  end

  # DELETE /graficos/1
  def destroy
    raise Acl9::AccessDenied unless @grafico.modificable?

    @grafico.destroy
    redirect_to graficos_url,
      notice: 'Se eliminó correctamente el gráfico.'
  end

  private
    def establecer_grafico
      @grafico = Grafico.find(params[:id])
      raise Acl9::AccessDenied if @grafico.propietario != usuario_actual && !@grafico.publico
    end

    def grafico_parametros
      params.require(:grafico).permit(
          :nombre, :descripcion, :tipo_de_evaluacion_id, :titulo, :subtitulo,
          :etiqueta_eje_x, :etiqueta_eje_y, :publico
        )
    end

    def implementacion_parametros(modelo)
      case modelo
        when "GraficoTb"
          params.require(:grafico_tb).permit(
              :fuente_eventos_observados, :fuente_poblacion, :multiplicador
            )
        when "GraficoTad"
          params.require(:grafico_tad).permit(
              :fuente_eventos_observados, :fuente_poblacion, :multiplicador
            )
        else
          {}
      end
    end
end
