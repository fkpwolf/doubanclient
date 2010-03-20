require 'test_helper'

class VisitlogsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:visitlogs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create visitlog" do
    assert_difference('Visitlog.count') do
      post :create, :visitlog => { }
    end

    assert_redirected_to visitlog_path(assigns(:visitlog))
  end

  test "should show visitlog" do
    get :show, :id => visitlogs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => visitlogs(:one).to_param
    assert_response :success
  end

  test "should update visitlog" do
    put :update, :id => visitlogs(:one).to_param, :visitlog => { }
    assert_redirected_to visitlog_path(assigns(:visitlog))
  end

  test "should destroy visitlog" do
    assert_difference('Visitlog.count', -1) do
      delete :destroy, :id => visitlogs(:one).to_param
    end

    assert_redirected_to visitlogs_path
  end
end
