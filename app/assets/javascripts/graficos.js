$(document).ready(function() {
  $("#grafico_tipo_de_evaluacion_id").change(function() {
    if ($("#grafico_tipo_de_evaluacion_id").val() != "") {
      $("#leyenda_seleccion").hide();
      var ruta = $("#grafico_tipo_de_evaluacion_id :selected").data("ruta");
      $.ajax({
        url: ruta + "?" + $.param($("#implementacion").data("grafico")) + "&" + $.param({"validar": $("#implementacion").data("validar")})
      }).done(function(html_text) {
        var text = html_text.replace(/.*<!-- start -->/m, "");
        text = text.replace(/\/<!-- end -->.*/m, "");
        $("#implementacion").html(text);
        // Configuraciones específicas de las distintas implementaciones de gráficos (si las requieren)
        // luego de cargar el subformulario de implementación
        $("#grafico_tb_fuente_poblacion").chained("#grafico_tb_fuente_eventos_observados");
        $("#grafico_tb_fuente_eventos_observados").change();
        $("#grafico_tad_fuente_poblacion").chained("#grafico_tad_fuente_eventos_observados");
        $("#grafico_tad_fuente_eventos_observados").change();
      });
    }
    else {
      $("#leyenda_seleccion").show();
    }
  });

  // Forzar el disparo del evento 'change' para la selección del tipo de evaluación
  $("#grafico_tipo_de_evaluacion_id").change();

});