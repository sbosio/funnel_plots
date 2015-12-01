class CategoriasDeLaCovariableController < ApplicationController
  before_action :establecer_categoria_de_la_covariable, only: [:show, :edit, :update, :destroy]

  access_control do
    # TODO: Revisar los controles de acceso. Por ahora solo verificamos propiedad en las distintas acciones
    allow all
  end

  # GET /categorias_de_la_covariable/1
  def show
  end

  # GET /categorias_de_la_covariable/1/edit
  def edit
  end

  # PATCH/PUT /categorias_de_la_covariable/1
  def update
    if @categoria_de_la_covariable.update(categoria_de_la_covariable_parametros)
      redirect_to @categoria_de_la_covariable, notice: 'La categoría de la covariable se modificó correctamente.'
    else
      render :edit
    end
  end

  # DELETE /categorias_de_la_covariable/1
  def destroy
    raise Acl9::AccessDenied unless @categoria_de_la_covariable.covariable.modificable?

    @categoria_de_la_covariable.destroy
    redirect_to @categoria_de_la_covariable.covariable,
      notice: 'La categoría de la covariable se eliminó correctamente.'
  end

  private
    def establecer_categoria_de_la_covariable
      @categoria_de_la_covariable = CategoriaDeLaCovariable.find(params[:id])
      rails Acl9::AccessDenied if @categoria_de_la_covariable.propietario != usuario_actual
    end

    def categoria_de_la_covariable_parametros
      params.require(:categoria_de_la_covariable).permit(:nombre, :descripcion)
    end
end
