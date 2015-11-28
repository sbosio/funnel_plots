# Reiniciar el servidor cada vez que se modifique este archivo

# Modificar el módulo ActiveSupport::Inflector para generar inflexiones en español
# En Rails 4 viene soldada (hardcoded) en el código la localización inglesa (':en') y no es posible cambiarla
# mediante configuración.
module ActiveSupport::Inflector

  # En forma predeterminada el método pluralize utilizará la localización ':es'
  def pluralize(palabra, localizacion = :es)
    aplicar_inflecciones(palabra, inflections(localizacion).plurals)
  end

  # En forma predeterminada el método singularize utilizará la localización ':es'
  def singularize(palabra, localizacion = :es)
    aplicar_inflecciones(palabra, inflections(localizacion).singulars)
  end

private

  # El método 'aplicar_inflecciones' reemplaza al método 'apply_inflections', permitiendo que la verificación
  # de incontables se realice específicamente sobre la localización ':es', y además habilitando que las
  # reglas de reemplazo puedan ser dinámicas, mediante la utilización de 'lambdas'.
  def aplicar_inflecciones(cadena, reglas)
    resultado = cadena.to_s.dup

    if cadena.empty? || inflections(:es).uncountables.include?(resultado.downcase[/\b\w+\Z/])
      resultado
    else
      reglas.each do |(regla, reemplazo)|
        if reemplazo.respond_to?(:call)
          break if resultado.gsub!(regla, &reemplazo)
        else
          break if resultado.gsub!(regla, reemplazo)
        end
      end
    end
    resultado
  end

end

# También es necesario modificar la clase String porque en Rails 4 los métodos 'pluralize' y 'singularize' en
# forma predeterminada usan la localización inglesa (':en') y está soldada en el código (no se puede cambiar
# por configuración)

class String

  # En forma predeterminada el método 'pluralize' utilizará la localización ':es'
  def pluralize(cuenta = nil, localizacion = :es)
    localizacion = cuenta if cuenta.is_a?(Symbol)
    if cuenta == 1
      self
    else
      ActiveSupport::Inflector.pluralize(self, localizacion)
    end
  end

  # En forma predeterminada el método 'singularize' utilizará la localización ':es'
  def singularize(localizacion = :es)
    ActiveSupport::Inflector.singularize(self, localizacion)
  end

end

ActiveSupport::Inflector.inflections(:es) do |infleccion|
  # Modificamos las reglas básicas de inflección de la gema 'inflections' para la localización ':es'
  # añadiendo un par de reglas que, en caso de pasar una cadena con espacios o caracteres de subrayado,
  # solo pluraliza la primer palabra, dejando el resto intacto (es lo mejor que se puede conseguir
  # considerando las utilidades internas del inflector en los métodos que convierten nombres de tablas y
  # clases).
  infleccion.plural(/^(\w+)([\s|_])(.+)$/,
    lambda do |coincidencia|
      separador = coincidencia.match(/^(\w+)([\s|_])(.+)$/)[2]
      primera, resto = coincidencia.split(separador, 2)
      "#{primera.pluralize}#{separador}#{resto}"
    end
  )

  infleccion.singular(/^(\w+)([\s|_])(.+)$/,
    lambda do |coincidencia|
      separador = coincidencia.match(/^(\w+)([\s|_])(.+)$/)[2]
      primera, resto = coincidencia.split(separador, 2)
      "#{primera.singularize}#{separador}#{resto}"
    end
  )

  infleccion.irregular("covariable", "covariables")
  infleccion.irregular("rol_asignable", "roles_asignables")
  infleccion.irregular("permiso_otorgado", "permisos_otorgados")
  infleccion.irregular("categoria_de_la_covariable", "categorias_de_la_covariable")

end
