require File.dirname(__FILE__) + '/../test_helper'
require 'colors_controller'

# Re-raise errors caught by the controller.
class ColorsController; def rescue_action(e) raise e end; end

class ColorsControllerTest < Test::Unit::TestCase
  fixtures :colors

  def setup
    @controller = ColorsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = colors(:first).id
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

    assert_not_nil assigns(:colors)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:color)
    assert assigns(:color).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:color)
  end

  def test_create
    num_colors = Color.count

    post :create, :color => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_colors + 1, Color.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:color)
    assert assigns(:color).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Color.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Color.find(@first_id)
    }
  end
end
