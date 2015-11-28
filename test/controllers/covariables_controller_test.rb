require 'test_helper'

class CovariablesControllerTest < ActionController::TestCase
  setup do
    @covariabl = covariables(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:covariables)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create covariabl" do
    assert_difference('Covariable.count') do
      post :create, covariabl: { created_user: @covariabl.created_user, descripcion: @covariabl.descripcion, nombre: @covariabl.nombre, updated_user: @covariabl.updated_user }
    end

    assert_redirected_to covariabl_path(assigns(:covariabl))
  end

  test "should show covariabl" do
    get :show, id: @covariabl
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @covariabl
    assert_response :success
  end

  test "should update covariabl" do
    patch :update, id: @covariabl, covariabl: { created_user: @covariabl.created_user, descripcion: @covariabl.descripcion, nombre: @covariabl.nombre, updated_user: @covariabl.updated_user }
    assert_redirected_to covariabl_path(assigns(:covariabl))
  end

  test "should destroy covariabl" do
    assert_difference('Covariable.count', -1) do
      delete :destroy, id: @covariabl
    end

    assert_redirected_to covariables_path
  end
end
