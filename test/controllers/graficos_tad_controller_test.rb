require 'test_helper'

class GraficosTadControllerTest < ActionController::TestCase
  setup do
    @grafico_tad = graficos_tad(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:graficos_tad)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create grafico_tad" do
    assert_difference('GraficoTad.count') do
      post :create, grafico_tad: { fuente_eventos_observados: @grafico_tad.fuente_eventos_observados, fuente_poblacion: @grafico_tad.fuente_poblacion, multiplicador: @grafico_tad.multiplicador }
    end

    assert_redirected_to grafico_tad_path(assigns(:grafico_tad))
  end

  test "should show grafico_tad" do
    get :show, id: @grafico_tad
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @grafico_tad
    assert_response :success
  end

  test "should update grafico_tad" do
    patch :update, id: @grafico_tad, grafico_tad: { fuente_eventos_observados: @grafico_tad.fuente_eventos_observados, fuente_poblacion: @grafico_tad.fuente_poblacion, multiplicador: @grafico_tad.multiplicador }
    assert_redirected_to grafico_tad_path(assigns(:grafico_tad))
  end

  test "should destroy grafico_tad" do
    assert_difference('GraficoTad.count', -1) do
      delete :destroy, id: @grafico_tad
    end

    assert_redirected_to graficos_tad_path
  end
end
