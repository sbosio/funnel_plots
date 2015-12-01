TipoDeEvaluacion.create([
  {
    nombre: "Tasa bruta",
    codigo: "TB",
    descripcion:
      "Este tipo de evaluación puede utilizarse bajo los siguientes supuestos:\n" +
      "· \n" +
      "· \n" +
      "· \n",
    ruta_de_formulario: "/graficos_tb/form",
    modelo_de_implementacion: "GraficoTb"
  },
  {
    nombre: "Tasa ajustada directamente",
    codigo: "TAD",
    descripcion:
      "Este tipo de evaluación puede utilizarse bajo los siguientes supuestos:\n" +
      "· \n" +
      "· \n" +
      "· \n",
    ruta_de_formulario: "/graficos_tad/form",
    modelo_de_implementacion: "GraficoTad"
  },
  {
    nombre: "Tasa ajustada indirectamente",
    codigo: "TAI",
    descripcion:
      "Este tipo de evaluación puede utilizarse bajo los siguientes supuestos:\n" +
      "· \n" +
      "· \n" +
      "· \n",
    ruta_de_formulario: nil # no implementado
  }
])