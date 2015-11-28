require 'test_helper'

class ConjuntosDeUnidadesDeAnalisisControllerTest < ActionController::TestCase
  setup do
    @conjunto_de_unidades_de_analisis = conjuntos_de_unidades_de_analisis(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:conjuntos_de_unidades_de_analisis)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create conjunto_de_unidades_de_analisis" do
    assert_difference('ConjuntoDeUnidadesDeAnalisis.count') do
      post :create, conjunto_de_unidades_de_analisis: { created_user_id: @conjunto_de_unidades_de_analisis.created_user_id, descripcion: @conjunto_de_unidades_de_analisis.descripcion, nombre: @conjunto_de_unidades_de_analisis.nombre, tipo_de_unidad_de_analisis_id: @conjunto_de_unidades_de_analisis.tipo_de_unidad_de_analisis_id, updated_user_id: @conjunto_de_unidades_de_analisis.updated_user_id }
    end

    assert_redirected_to conjunto_de_unidades_de_analisis_path(assigns(:conjunto_de_unidades_de_analisis))
  end

  test "should show conjunto_de_unidades_de_analisis" do
    get :show, id: @conjunto_de_unidades_de_analisis
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @conjunto_de_unidades_de_analisis
    assert_response :success
  end

  test "should update conjunto_de_unidades_de_analisis" do
    patch :update, id: @conjunto_de_unidades_de_analisis, conjunto_de_unidades_de_analisis: { created_user_id: @conjunto_de_unidades_de_analisis.created_user_id, descripcion: @conjunto_de_unidades_de_analisis.descripcion, nombre: @conjunto_de_unidades_de_analisis.nombre, tipo_de_unidad_de_analisis_id: @conjunto_de_unidades_de_analisis.tipo_de_unidad_de_analisis_id, updated_user_id: @conjunto_de_unidades_de_analisis.updated_user_id }
    assert_redirected_to conjunto_de_unidades_de_analisis_path(assigns(:conjunto_de_unidades_de_analisis))
  end

  test "should destroy conjunto_de_unidades_de_analisis" do
    assert_difference('ConjuntoDeUnidadesDeAnalisis.count', -1) do
      delete :destroy, id: @conjunto_de_unidades_de_analisis
    end

    assert_redirected_to conjuntos_de_unidades_de_analisis_path
  end
end
