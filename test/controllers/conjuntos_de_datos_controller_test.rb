require 'test_helper'

class ConjuntosDeDatosControllerTest < ActionController::TestCase
  setup do
    @conjunto_de_datos = conjuntos_de_datos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:conjuntos_de_datos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create conjunto_de_datos" do
    assert_difference('ConjuntoDeDatos.count') do
      post :create, conjunto_de_datos: { created_user: @conjunto_de_datos.created_user, descripcion: @conjunto_de_datos.descripcion, nombre: @conjunto_de_datos.nombre, updated_user: @conjunto_de_datos.updated_user }
    end

    assert_redirected_to conjunto_de_datos_path(assigns(:conjunto_de_datos))
  end

  test "should show conjunto_de_datos" do
    get :show, id: @conjunto_de_datos
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @conjunto_de_datos
    assert_response :success
  end

  test "should update conjunto_de_datos" do
    patch :update, id: @conjunto_de_datos, conjunto_de_datos: { created_user: @conjunto_de_datos.created_user, descripcion: @conjunto_de_datos.descripcion, nombre: @conjunto_de_datos.nombre, updated_user: @conjunto_de_datos.updated_user }
    assert_redirected_to conjunto_de_datos_path(assigns(:conjunto_de_datos))
  end

  test "should destroy conjunto_de_datos" do
    assert_difference('ConjuntoDeDatos.count', -1) do
      delete :destroy, id: @conjunto_de_datos
    end

    assert_redirected_to conjuntos_de_datos_path
  end
end
