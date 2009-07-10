require File.dirname(__FILE__) + '/../test_helper'
require 'animals_controller'

# Re-raise errors caught by the controller.
class AnimalsController; def rescue_action(e) raise e end; end

class AnimalsControllerTest < Test::Unit::TestCase
  fixtures :animals

  def setup
    @controller = AnimalsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = animals(:first).id
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

    assert_not_nil assigns(:animals)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:animal)
    assert assigns(:animal).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:animal)
  end

  def test_create
    num_animals = Animal.count

    post :create, :animal => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_animals + 1, Animal.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:animal)
    assert assigns(:animal).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Animal.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Animal.find(@first_id)
    }
  end
end
