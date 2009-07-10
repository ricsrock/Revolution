require File.dirname(__FILE__) + '/../test_helper'
require 'adjectives_controller'

# Re-raise errors caught by the controller.
class AdjectivesController; def rescue_action(e) raise e end; end

class AdjectivesControllerTest < Test::Unit::TestCase
  fixtures :adjectives

  def setup
    @controller = AdjectivesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = adjectives(:first).id
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

    assert_not_nil assigns(:adjectives)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:adjective)
    assert assigns(:adjective).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:adjective)
  end

  def test_create
    num_adjectives = Adjective.count

    post :create, :adjective => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_adjectives + 1, Adjective.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:adjective)
    assert assigns(:adjective).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Adjective.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Adjective.find(@first_id)
    }
  end
end
