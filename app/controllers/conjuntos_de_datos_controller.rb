class ConjuntosDeDatosController < ApplicationController
  before_action :set_conjunto_de_datos, only: [:show, :edit, :update, :destroy]

  # GET /conjuntos_de_datos
  # GET /conjuntos_de_datos.json
  def index
    @conjuntos_de_datos = ConjuntoDeDatos.all
  end

  # GET /conjuntos_de_datos/1
  # GET /conjuntos_de_datos/1.json
  def show
  end

  # GET /conjuntos_de_datos/new
  def new
    @conjunto_de_datos = ConjuntoDeDatos.new
  end

  # GET /conjuntos_de_datos/1/edit
  def edit
  end

  # POST /conjuntos_de_datos
  # POST /conjuntos_de_datos.json
  def create
    @conjunto_de_datos = ConjuntoDeDatos.new(conjunto_de_datos_params)

    respond_to do |format|
      if @conjunto_de_datos.save
        format.html { redirect_to @conjunto_de_datos, notice: 'Conjunto de datos was successfully created.' }
        format.json { render :show, status: :created, location: @conjunto_de_datos }
      else
        format.html { render :new }
        format.json { render json: @conjunto_de_datos.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conjuntos_de_datos/1
  # PATCH/PUT /conjuntos_de_datos/1.json
  def update
    respond_to do |format|
      if @conjunto_de_datos.update(conjunto_de_datos_params)
        format.html { redirect_to @conjunto_de_datos, notice: 'Conjunto de datos was successfully updated.' }
        format.json { render :show, status: :ok, location: @conjunto_de_datos }
      else
        format.html { render :edit }
        format.json { render json: @conjunto_de_datos.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conjuntos_de_datos/1
  # DELETE /conjuntos_de_datos/1.json
  def destroy
    @conjunto_de_datos.destroy
    respond_to do |format|
      format.html { redirect_to conjuntos_de_datos_url, notice: 'Conjunto de datos was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conjunto_de_datos
      @conjunto_de_datos = ConjuntoDeDatos.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conjunto_de_datos_params
      params.require(:conjunto_de_datos).permit(:nombre, :descripcion, :created_user, :updated_user)
    end
end
