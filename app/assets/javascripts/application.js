// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui/datepicker
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require dataTables/jquery.dataTables.foundation
//= require foundation
//= require confirm_with_reveal
//= require slick
//= require spin
//= require jquery.chained
//= require select2
//= require select2_locale_es
//= require jquery_nested_form
//= require highcharts/highcharts
//= require highcharts/highcharts-more
//= require highcharts/modules/exporting
//= require_tree .

$(document).confirmWithReveal({
  ok: 'Aceptar',
  ok_class: 'button alert small round',
  cancel: 'Cancelar',
  cancel_class: 'button secondary small round'
});


jQuery(function($){
  $.datepicker.regional['es'] = {
    closeText: 'Cerrar',
    prevText: '&#x3c;Ant',
    nextText: 'Sig&#x3e;',
    currentText: 'Hoy',
    monthNames: ['Enero','Febrero','Marzo','Abril','Mayo','Junio',
      'Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'],
    monthNamesShort: ['Ene','Feb','Mar','Abr','May','Jun',
      'Jul','Ago','Sep','Oct','Nov','Dic'],
    dayNames: ['Domingo','Lunes','Martes','Mi&eacute;rcoles','Jueves','Viernes','S&aacute;bado'],
    dayNamesShort: ['Dom','Lun','Mar','Mi&eacute;','Juv','Vie','S&aacute;b'],
    dayNamesMin: ['Do','Lu','Ma','Mi','Ju','Vi','S&aacute;'],
    weekHeader: 'Sm',
    dateFormat: 'yy-mm-dd',
    firstDay: 1,
    isRTL: false,
    showMonthAfterYear: false,
    yearSuffix: ''};
  $.datepicker.setDefaults($.datepicker.regional['es']);
});

$(document).ready(function(){
  $('.carousel').slick({
    adaptiveHeight: true,
    fade: false,
    infinite: false,
    prevArrow: '<button type="button" class="tiny round">Anterior</button>',
    nextArrow: '<button type="button" class="tiny round">Siguiente</button>'
  });

  $('.tabla_de_datos').DataTable({
    language: {
      "sProcessing":     "Procesando...",
      "sLengthMenu":     "Mostrar _MENU_ registros",
      "sZeroRecords":    "No se encontraron resultados",
      "sEmptyTable":     "Ningún dato disponible en esta tabla",
      "sInfo":           "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
      "sInfoEmpty":      "Mostrando registros del 0 al 0 de un total de 0 registros",
      "sInfoFiltered":   "(filtrado de un total de _MAX_ registros)",
      "sInfoPostFix":    "",
      "sSearch":         "Buscar:",
      "sUrl":            "",
      "sInfoThousands":  ",",
      "sLoadingRecords": "Cargando...",
      "oPaginate": {
          "sFirst":    "Primero",
          "sLast":     "Último",
          "sNext":     "Siguiente",
          "sPrevious": "Anterior"
      },
      "oAria": {
          "sSortAscending":  ": Activar para ordenar la columna de manera ascendente",
          "sSortDescending": ": Activar para ordenar la columna de manera descendente"
      }
    }
  });

  $('.datepicker').datepicker( { changeMonth: false }, $.datepicker.regional[ "es" ]); //Jquery Datepicker

  $('.boton_de_accion').click( function () {
    if($(this).hasClass('disabled'))
      return false;
  });

  $('i[data-show]').on('click', function(e){
    e.preventDefault();
    show_selector = $(this).data("show");
    hide_selector = $(this).data("hide");

    if (show_selector != "")
      $(show_selector).show();
    if (hide_selector != "")
      $(hide_selector).hide();
  });
});

$(document).ready(function() {
  $('.select2').each(function(i, e){
    var select = $(e);
    options = {
      minimumInputLength: (select.data('caracteresminimos') == undefined) ? '0' : select.data('caracteresminimos'),
      allowClear: true,
      width: 'resolve',
      dropdownAutoWidth : true
    };

    if(select.data('funcion-de-formato') != undefined || select.data('funcion-de-formato') != "") {
      options.formatResult = eval(select.data('funcion-de-formato'));
      options.formatSelection = eval(select.data('funcion-de-formato-seleccionada'));
    }
    // Agrega las opciones adicionales de creacion.
    // TODO: reemplazar por $.extend y sacar el eval
    if( select.data('opciones') != undefined){
      opc = select.data('opciones');
      for(var o in opc)
        eval("options."+ o +" = opc."+o );
    }

    if (select.hasClass('ajax')) {
      if (select.data('parametros-adicionales') == undefined )
        select.data('parametros-adicionales',  '');

      options.ajax = {
        url: select.data('source'),
        dataType: 'json',
        quietMillis: 170,
        data: function(term, page) {
          ret = {
            q: term,
            page: page,
            per: 10,
            // DEPRECATION WARNING:
            // envio los parametros adicionales como valores - Dejo el array tambien para compatibilidad hacia atras
            parametros_adicionales: (select.data('parametros-adicionales') == undefined) ? '' : eval("({"+ select.data('parametros-adicionales') + "})")
          }

          var params = {};
          if( select.data('parametros-adicionales') != undefined){
            //Convierto los datos adicionales en un obj
            params = jQuery.parseJSON( JSONize("{"+ select.data('parametros-adicionales') + "}")  );
          }
          //agrego los parametros adicionales al obj sin estar en el array
          $.extend( ret, ret, params );
          return ret
        },
        results: function(data, page) { return { more: data.total > (page * 10), results: eval("data." + select.data('coleccion'))} }
      }
    } // end if (select.hasClass('ajax')) {

    if(select.hasClass('dependiente') && select.data('id-padre') != undefined )
    {
      //Busco los padres:
      padres = []
      if($.trim(select.data('parametros-adicionales')) == "")
        parametros_adicionales = [];
      else
        parametros_adicionales = $.trim(select.data('parametros-adicionales')).split(",");

      $.each(select.data('id-padre').split(","), function(indice, padre_id){
        padre = $("#"+$.trim(padre_id));

        //Si lo encuentra
        if(padre.length)
        {
          padres.push(padre)
          //Guardo los parametros adicionales estaticos y agrego el id de este padre en los parametros adicionales

          padre_val = ' -1';
          if (padre.val() !== undefined && padre.val() != '' )
            padre_val = " "+ padre.val();

          parametros_adicionales.push($.trim(padre_id)+':'+padre_val);
          select.data('parametros-adicionales', parametros_adicionales.join(","))

          //A cada padre lo seteo para que cuando cambie el valor, actualice los parametros que envia via ajax
          padres[indice].change( function(evt){

            arr_parametros_adicionales = [];
            $.each(select.data('parametros-adicionales').split(","),function(idx_parametro, parametro){
              //reconstruyo el string de parametros adicionales cambiando solo el nuevo valor del padre
              nombre_parametro = $.trim(parametro.split(":")[0]);
              valor_parametro  = $.trim(parametro.split(":")[1]);
              //Si no paso parametros adicionales
              if(nombre_parametro.length != 0)
              {
                if(nombre_parametro == evt.currentTarget.id)
                  valor_parametro = evt.currentTarget.value;
                arr_parametros_adicionales.push(nombre_parametro+":"+valor_parametro+" ");
              }
            }); //end each parametros-adicionales
            select.data('parametros-adicionales', arr_parametros_adicionales.join(",") );
          }); //end on change
          //Disparo el change para que si los padres ya tenian valores, le setee el valor a este depediente
          padre.trigger("change");
        } // end if (si encontro el padre)
        else
          throw "No se encontro el elemento: "+"'"+padre_id+"'";
      });//end each padre
    } //end class dependiente

    if (select.hasClass('ajax') ) {
      options.initSelection =  function (element, callback) {
        // Dejo el valor como rails lo envió.
        var ids = $.trim($(element).val());

        //  Rails envia los arrays como arrays al value. A select 2 los toma como lista separados x comas,
        // asique reemplazo el array para q select2 no se confunda y duplique elementos en los valores
        $(element).val(ids.replace("[", "").replace("]", "")); //Elimino el valor del value html.

        if( ids !== "[]"){
          ret = {
            ids: ids,
            // DEPRECATION WARNING:
            // envio los parametros adicionales como valores - Dejo el array tambien para compatibilidad hacia atras
            parametros_adicionales: (select.data('parametros-adicionales') == undefined) ? '' : eval("({"+ select.data('parametros-adicionales') + "})")
          }

          var params = {};
          if( select.data('parametros-adicionales') != undefined)
            params = jQuery.parseJSON( JSONize("{"+ select.data('parametros-adicionales') + "}")  ); //Convierto los datos adicionales en un obj
          //agrego los parametros adicionales al obj sin estar en el array
          $.extend( ret, ret, params );
          // Pasando los args como json puedo hacer una sola llamada ajax y lo agarra el format selection del select2.
          $.ajax({
            url: select.data('source'),
            dataType: "json",
            data: ret
          })
          .done( function(data) {
            /*
             *  Esta diferencia es porque el select2 es una garcha que manda
             * los argumentos como array o como objeto dependiendo de la configuracion del
             * select2, en lugar de considerar q simplemente es una llamada ajax.
            */
            if (select.data('opciones').multiple == true) {
              callback( eval("data." + select.data('coleccion')) );
            } else{
              callback( eval("data." + select.data('coleccion') + "[0]" ) );
            };
          });
        } //end if los ids!=="[]"
      } //end function initSelection
    } //end if multiple

    select.select2(options);
  })
});

GLOBAL_DATATABLES_LENGUAGE = {
  "sProcessing":     "Procesando...",
  "sLengthMenu":     "Mostrar _MENU_ registros",
  "sZeroRecords":    "No se encontraron resultados",
  "sEmptyTable":     "Ningún dato disponible en esta tabla",
  "sInfo":           "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
  "sInfoEmpty":      "Mostrando registros del 0 al 0 de un total de 0 registros",
  "sInfoFiltered":   "(filtrado de un total de _MAX_ registros)",
  "sInfoPostFix":    "",
  "sSearch":         "Buscar:",
  "sUrl":            "",
  "sInfoThousands":  ",",
  "sLoadingRecords": "Cargando...",
  "oPaginate": {
      "sFirst":    "Primero",
      "sLast":     "Último",
      "sNext":     "Siguiente",
      "sPrevious": "Anterior"
  },
  "oAria": {
      "sSortAscending":  ": Activar para ordenar la columna de manera ascendente",
      "sSortDescending": ": Activar para ordenar la columna de manera descendente"
  }
};

$(function(){ $(document).foundation(); });

$(document).ready(function(){
  Highcharts.setOptions({
      lang: {
          contextButtonTitle: "Menú contextual",
          decimalPoint: ",",
          downloadJPEG: "Descargar JPEG",
          downloadPDF: "Descargar PDF",
          downloadPNG: "Descargar PNG",
          downloadSVG: "Descargar SVG",
          drillUpText: "Volver a {series.name}",
          invalidDate: "Fecha no válida",
          loading: "Cargando...",
          months: [
              "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio",
              "Agosto", "Setiembre", "Octubre", "Noviembre", "Diciembre"
            ],
          noData: "Sin datos para mostrar",
          printChart: "Imprimir gráfico",
          resetZoom: "Restablecer escala",
          resetZoomTitle: "Restablecer a escala 1:1",
          shortMonths: [
              "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul",
              "Ago", "Set", "Oct", "Nov", "Dic"
            ],
          thousandsSep: ".",
          weekdays: ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"]
        }
    });
});