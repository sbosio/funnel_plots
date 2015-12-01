class GraficosTbController < ApplicationController
  before_action :autenticar_usuario!
  before_action :establecer_grafico_tb

  access_control do
    # TODO: Revisar los controles de acceso. Por ahora solo verificamos propiedad en las distintas acciones
    allow all
  end

  # GET /graficos_tb/form
  def form
    @fuentes_eventos_observados =
      ConjuntoDeDatos.where(
          created_user: usuario_actual.id
        ).map do |fuente|
          if fuente.datos.size > 0
            [fuente.nombre, fuente.id, 'data-conjunto': fuente.conjunto_de_unidades_de_analisis.id]
          else
            [
              fuente.nombre, fuente.id,
              'data-conjunto': fuente.conjunto_de_unidades_de_analisis.id,
              disabled: true, title: "No se han cargado los datos"
            ]
          end
        end
    @fuentes_poblacion = []
    @fuentes_eventos_observados.each do |fuente|
      ConjuntoDeDatos.where(
        created_user: usuario_actual.id,
        conjunto_de_unidades_de_analisis_id: fuente[2][:'data-conjunto']
      ).each do |c|
        if c.datos.size > 0
          if c.id != fuente[1]
            @fuentes_poblacion << [c.nombre, c.id, class: fuente[1]]
          else
            @fuentes_poblacion << [
                c.nombre, c.id, class: fuente[1],
                disabled: true, title: "Fuente de eventos observados"
              ]
          end
        else
          @fuentes_poblacion << [
              c.nombre, c.id, class: fuente[1],
              disabled: true, title: "No se han cargado los datos"
            ]
        end
      end
    end

    render partial: 'form'
  end

  def edit
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def establecer_grafico_tb
      implementacion_parametros = params.require(:grafico).permit(
          implementacion: [:fuente_eventos_observados, :fuente_poblacion, :multiplicador]
        )[:implementacion]
      if params.require(:grafico).permit(:implementacion_type)[:implementacion_type] == ""
        @grafico_tb = GraficoTb.new(implementacion_parametros)
      elsif params.require(:grafico).permit(:implementacion_type)[:implementacion_type] == "GraficoTb"
        if params.require(:grafico).permit(:implementacion_id)[:implementacion_id] != ""
          @grafico_tb = GraficoTb.find(params.require(:grafico).permit(:implementacion_id)[:implementacion_id])
          raise Acl9::AccessDenied if @grafico_tb.propietario != usuario_actual
          @grafico_tb.attributes = implementacion_parametros
        else
          @grafico_tb = GraficoTb.new(implementacion_parametros)
        end
      else
        raise Acl9::AccessDenied
      end
      if params[:validar] == "true"
        @grafico_tb.valid?
      end
    end
end
