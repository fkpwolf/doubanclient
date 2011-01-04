require 'test_helper'

class CachesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:caches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cache" do
    assert_difference('Cache.count') do
      post :create, :cache => { }
    end

    assert_redirected_to cache_path(assigns(:cache))
  end

  test "should show cache" do
    get :show, :id => caches(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => caches(:one).to_param
    assert_response :success
  end

  test "should update cache" do
    put :update, :id => caches(:one).to_param, :cache => { }
    assert_redirected_to cache_path(assigns(:cache))
  end

  test "should destroy cache" do
    assert_difference('Cache.count', -1) do
      delete :destroy, :id => caches(:one).to_param
    end

    assert_redirected_to caches_path
  end
end
