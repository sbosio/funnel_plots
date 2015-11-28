require 'test_helper'

class UnidadesDeAnalisisControllerTest < ActionController::TestCase
  setup do
    @unidad_de_analisis = unidades_de_analisis(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:unidades_de_analisis)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create unidad_de_analisis" do
    assert_difference('UnidadDeAnalisis.count') do
      post :create, unidad_de_analisis: { conjunto_de_unidades_de_analisis_id: @unidad_de_analisis.conjunto_de_unidades_de_analisis_id, created_user_id: @unidad_de_analisis.created_user_id, descripcion: @unidad_de_analisis.descripcion, nombre: @unidad_de_analisis.nombre, updated_user_id: @unidad_de_analisis.updated_user_id }
    end

    assert_redirected_to unidad_de_analisis_path(assigns(:unidad_de_analisis))
  end

  test "should show unidad_de_analisis" do
    get :show, id: @unidad_de_analisis
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @unidad_de_analisis
    assert_response :success
  end

  test "should update unidad_de_analisis" do
    patch :update, id: @unidad_de_analisis, unidad_de_analisis: { conjunto_de_unidades_de_analisis_id: @unidad_de_analisis.conjunto_de_unidades_de_analisis_id, created_user_id: @unidad_de_analisis.created_user_id, descripcion: @unidad_de_analisis.descripcion, nombre: @unidad_de_analisis.nombre, updated_user_id: @unidad_de_analisis.updated_user_id }
    assert_redirected_to unidad_de_analisis_path(assigns(:unidad_de_analisis))
  end

  test "should destroy unidad_de_analisis" do
    assert_difference('UnidadDeAnalisis.count', -1) do
      delete :destroy, id: @unidad_de_analisis
    end

    assert_redirected_to unidades_de_analisis_path
  end
end
