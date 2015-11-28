json.array!(@conjuntos_de_datos) do |conjunto_de_datos|
  json.extract! conjunto_de_datos, :id, :nombre, :descripcion, :created_user, :updated_user
  json.url conjunto_de_datos_url(conjunto_de_datos, format: :json)
end
