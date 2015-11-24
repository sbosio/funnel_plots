Usuario.create([
  {
    nombre: "Administrador",
    apellido: "",
    sexo: Sexo.find(2),
    email: "funnel.plots@gmail.com",
    password: "147258369",
    confirmed_at: Date.new(2015, 6, 1)
  }
])
