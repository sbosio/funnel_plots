require 'test_helper'

class CategoriasDeLaCovariableControllerTest < ActionController::TestCase
  setup do
    @categoria_de_la_covariable = categorias_de_la_covariable(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:categorias_de_la_covariable)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create categoria_de_la_covariable" do
    assert_difference('CategoriaDeLaCovariable.count') do
      post :create, categoria_de_la_covariable: { covariable_id: @categoria_de_la_covariable.covariable_id, created_user: @categoria_de_la_covariable.created_user, descripcion: @categoria_de_la_covariable.descripcion, nombre: @categoria_de_la_covariable.nombre, updated_user: @categoria_de_la_covariable.updated_user }
    end

    assert_redirected_to categoria_de_la_covariable_path(assigns(:categoria_de_la_covariable))
  end

  test "should show categoria_de_la_covariable" do
    get :show, id: @categoria_de_la_covariable
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @categoria_de_la_covariable
    assert_response :success
  end

  test "should update categoria_de_la_covariable" do
    patch :update, id: @categoria_de_la_covariable, categoria_de_la_covariable: { covariable_id: @categoria_de_la_covariable.covariable_id, created_user: @categoria_de_la_covariable.created_user, descripcion: @categoria_de_la_covariable.descripcion, nombre: @categoria_de_la_covariable.nombre, updated_user: @categoria_de_la_covariable.updated_user }
    assert_redirected_to categoria_de_la_covariable_path(assigns(:categoria_de_la_covariable))
  end

  test "should destroy categoria_de_la_covariable" do
    assert_difference('CategoriaDeLaCovariable.count', -1) do
      delete :destroy, id: @categoria_de_la_covariable
    end

    assert_redirected_to categorias_de_la_covariable_path
  end
end
