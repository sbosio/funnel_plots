class GraficoTb < ActiveRecord::Base
  include UserStamp

  # Acl9: es un objeto autorizable
  acts_as_authorization_object subject_class_name: "Usuario", role_class_name: "PermisoDeUsuario"

  # Asociaciones
  belongs_to  :eventos_observados, class_name: "ConjuntoDeDatos",
                foreign_key: :fuente_eventos_observados, counter_cache: :cuenta_de_graficos
  belongs_to  :poblacion, class_name: "ConjuntoDeDatos",
                foreign_key: :fuente_poblacion, counter_cache: :cuenta_de_graficos
  belongs_to  :propietario, foreign_key: :created_user, class_name: "Usuario"
  has_one     :grafico, as: :implementacion

  # Validaciones
  validates   :fuente_eventos_observados, :fuente_poblacion, presence: true
  validate    :multiplicador_valido, if: "multiplicador.present?"
  validate    :validar_selecciones, if: "fuente_eventos_observados.present? && fuente_poblacion.present?"

  def multiplicador_valido
    if multiplicador < 1
      self.errors.add(:multiplicador, "El multiplicador debe ser un número entero mayor o igual que 1")
    end
  end

  def validar_selecciones
    # TODO - STUB: Este método debería realizar validaciones sobre los conjuntos de datos y opciones seleccionadas
  end

  def obtener_grafico
    # Este método es el encargado de generar las series de datos de acuerdo con las selecciones
    # y devolver el objeto LazyHighCharts que se va a renderizar

    # Trabajamos con tasas brutas, así que debemos obtener los totales de cada conjunto de datos si
    # están definidos con alguna covariable

    # Serie de eventos observados (totales por unidad de análisis)
    serie_x = {}
    eventos_observados.conjunto_de_unidades_de_analisis.unidades_de_analisis.each do |unidad|
      serie_x.merge!(unidad => eventos_observados.datos.where(unidad_de_analisis_id: unidad.id).sum(:valor))
    end

    # Serie de población (totales por unidad de análisis)
    serie_N = {}
    poblacion.conjunto_de_unidades_de_analisis.unidades_de_analisis.each do |unidad|
      serie_N.merge!(unidad => poblacion.datos.where(unidad_de_analisis_id: unidad.id).sum(:valor))
    end

    # Ordenamos la serie de población de menor a mayor
    serie_N = serie_N.sort_by{|unidad, valor| valor}.to_h

    # Calculamos la media de la tasa global
    # TODO: Únicamente se grafica con un valor objetivo igual a la tasa media.
    #       Sumar una opción para establecer el valor objetivo a través de la interfaz.
    tasa_media = (serie_x.values.sum / serie_N.values.sum)

    # Calculamos la series requeridas para el gráfico
    # TODO: Está soldado el valor de desvíos estándares. Agregar una opción a la interfaz para que se
    #       tome de un valor pasado por el usuario.
    serie_lcs = {}
    serie_las = {}
    serie_media = {}
    serie_lai = {}
    serie_lci = {}
    serie_Y = {}
    mult = (multiplicador.present? ? multiplicador.to_f : 1.0)

    serie_N.each do |unidad, valor|
      # Desvío estándar para proporciones
      sigma = Math.sqrt(tasa_media * (1.0 - tasa_media) / valor)

      # Serie para el límite de control superior
      serie_lcs.merge!(
          unidad => (
              ((tasa_media + 3 * sigma) > 1.0 ? 1.0 : (tasa_media + 3 * sigma)) * mult
            )
        )

      # Serie para el límite de advertencia superior
      serie_las.merge!(
          unidad => (
              ((tasa_media + 2 * sigma) > 1.0 ? 1.0 : (tasa_media + 2 * sigma)) * mult
            )
        )

      # Serie para la media de la tasa general
      serie_media.merge!(unidad => (tasa_media * mult))

      # Serie para el límite de advertencia inferior
      serie_lai.merge!(
          unidad => (
              ((tasa_media - 2 * sigma) < 0.0 ? 0.0 : (tasa_media - 2 * sigma)) * mult
            )
        )

      # Serie para el límite de control inferior
      serie_lci.merge!(
          unidad => (
              ((tasa_media - 3 * sigma) < 0.0 ? 0.0 : (tasa_media - 3 * sigma)) * mult
            )
        )

      # Serie con las tasas por unidad de análisis
      serie_Y.merge!(unidad => (serie_x[unidad] / valor * mult))
    end

    LazyHighCharts::HighChart.new('graph') do |f|
      f.chart(type: 'scatter', zoomType: 'xy')
      f.title(text: grafico.titulo) if grafico.titulo.present?
      f.subtitle(text: grafico.subtitulo) if grafico.subtitulo.present?
      f.legend(enabled: false)
      f.xAxis(
          title: (
            grafico.etiqueta_eje_x.present? ?
            { enabled: true, text: grafico.etiqueta_eje_x } :
            { enabled: false }
          ),
          startOnTick: false,
          endOnTick: false,
          showLastLabel: false,
          min: serie_N.values.first.to_f,
          max: serie_N.values.last.to_f
        )

      f.yAxis(
          title: (
              grafico.etiqueta_eje_y.present? ?
              { enabled: true, text: grafico.etiqueta_eje_y } :
              { enabled: false }
            ),
          startOnTick: false,
          endOnTick: false,
          min: 0.0,
          max: serie_lcs.values.first.to_f
        )

      f.plotOptions(
          scatter: {
              tooltip: {
                  headerFormat: '<b>{point.key}</b><br/>',
                  pointFormat: 'Tasa: <b>{point.y:.1f}</b><br/>Nacidos vivos: <b>{point.x}</b>'
                }
            },
          spline: {
              marker: { enabled: false },
              tooltip: {
                  headerFormat: nil,
                  pointFormat: nil
                }
            }
        )

      # Serie para el límite de control superior
      f.series(
          name: 'Límite superior',
          type: 'spline',
          color: 'red',
          data: serie_lcs.map do |unidad, valor|
              { name: unidad.nombre, x: serie_N[unidad].to_f, y: valor.to_f }
            end
        )

      # Serie para el límite de advertencia superior
      f.series(
          name: 'Límite de advertencia superior',
          type: 'spline',
          color: 'yellow',
          data: serie_las.map do |unidad, valor|
              { name: unidad.nombre, x: serie_N[unidad].to_f, y: valor.to_f }
            end
        )

      # Serie para la tasa media
      f.series(
          name: 'Media',
          type: 'spline',
          color: 'green',
          data: serie_media.map do |unidad, valor|
              { name: unidad.nombre, x: serie_N[unidad].to_f, y: valor.to_f }
            end,
          tooltip: {
              headerFormat: '<b>Media</b><br/>',
              pointFormat: 'Tasa: <b>{point.y:.1f}</b>'
            },
          marker: {
              enabled: true,
              radius: 1
            }
        )

      # Serie para el límite de advertencia inferior
      f.series(
          name: 'Límite de advertencia inferior',
          type: 'spline',
          color: 'yellow',
          data: serie_lai.map do |unidad, valor|
              { name: unidad.nombre, x: serie_N[unidad].to_f, y: valor.to_f }
            end
        )

      # Serie para el límite de control inferior
      f.series(
          name: 'Límite inferior',
          type: 'spline',
          color: 'red',
          data: serie_lci.map do |unidad, valor|
              { name: unidad.nombre, x: serie_N[unidad].to_f, y: valor.to_f }
            end
        )

      # La serie X-Y
      f.series(
          name: 'Tasa',
          type: 'scatter',
          data: serie_Y.map do |unidad, valor|
              { name: unidad.nombre, x: serie_N[unidad].to_f, y: valor.to_f }
            end,
          marker: { symbol: 'circle' }
        )
    end
  end
end
