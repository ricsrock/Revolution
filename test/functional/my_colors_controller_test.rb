require File.dirname(__FILE__) + '/../test_helper'
require 'my_colors_controller'

# Re-raise errors caught by the controller.
class MyColorsController; def rescue_action(e) raise e end; end

class MyColorsControllerTest < Test::Unit::TestCase
  fixtures :my_colors

  def setup
    @controller = MyColorsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = my_colors(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:my_colors)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:my_color)
    assert assigns(:my_color).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:my_color)
  end

  def test_create
    num_my_colors = MyColor.count

    post :create, :my_color => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_my_colors + 1, MyColor.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:my_color)
    assert assigns(:my_color).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      MyColor.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      MyColor.find(@first_id)
    }
  end
end
