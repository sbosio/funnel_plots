class UnidadesDeAnalisisController < ApplicationController
  before_action :autenticar_usuario!
  before_action :establecer_unidad_de_analisis, only: [:show, :edit, :update, :destroy]

  access_control do
    # TODO: Revisar los controles de acceso. Por ahora solo verificamos propiedad en las distintas acciones
    allow all
  end

  # GET /unidades_de_analisis/1
  def show
  end

  # GET /unidades_de_analisis/1/edit
  def edit
  end

  # PATCH/PUT /unidades_de_analisis/1
  def update
    if @unidad_de_analisis.update(unidad_de_analisis_parametros)
      redirect_to @unidad_de_analisis, notice: 'La unidad de análisis se modificó correctamente.'
    else
      render :edit
    end
  end

  # DELETE /unidades_de_analisis/1
  def destroy
    raise Acl9::AccessDenied unless @unidad_de_analisis.conjunto_de_unidades_de_analisis.modificable?

    @unidad_de_analisis.destroy
    redirect_to @unidad_de_analisis.conjunto_de_unidades_de_analisis,
      notice: 'La unidad de análisis se eliminó correctamente.'
  end

  private
    def establecer_unidad_de_analisis
      @unidad_de_analisis = UnidadDeAnalisis.find(params[:id])
      raise Acl9::AccessDenied if @unidad_de_analisis.propietario != usuario_actual
    end

    def unidad_de_analisis_parametros
      params.require(:unidad_de_analisis).permit(:nombre, :descripcion)
    end
end
