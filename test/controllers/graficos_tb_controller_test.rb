require 'test_helper'

class GraficosTbControllerTest < ActionController::TestCase
  setup do
    @grafico_tb = graficos_tb(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:graficos_tb)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create grafico_tb" do
    assert_difference('GraficoTb.count') do
      post :create, grafico_tb: { fuente_eventos_observados: @grafico_tb.fuente_eventos_observados, fuente_poblacion: @grafico_tb.fuente_poblacion, multiplicador: @grafico_tb.multiplicador }
    end

    assert_redirected_to grafico_tb_path(assigns(:grafico_tb))
  end

  test "should show grafico_tb" do
    get :show, id: @grafico_tb
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @grafico_tb
    assert_response :success
  end

  test "should update grafico_tb" do
    patch :update, id: @grafico_tb, grafico_tb: { fuente_eventos_observados: @grafico_tb.fuente_eventos_observados, fuente_poblacion: @grafico_tb.fuente_poblacion, multiplicador: @grafico_tb.multiplicador }
    assert_redirected_to grafico_tb_path(assigns(:grafico_tb))
  end

  test "should destroy grafico_tb" do
    assert_difference('GraficoTb.count', -1) do
      delete :destroy, id: @grafico_tb
    end

    assert_redirected_to graficos_tb_path
  end
end
