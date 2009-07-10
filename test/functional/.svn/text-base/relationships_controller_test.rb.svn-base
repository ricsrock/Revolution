require File.dirname(__FILE__) + '/../test_helper'
require 'relationships_controller'

# Re-raise errors caught by the controller.
class RelationshipsController; def rescue_action(e) raise e end; end

class RelationshipsControllerTest < Test::Unit::TestCase
  fixtures :relationships

  def setup
    @controller = RelationshipsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = relationships(:first).id
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

    assert_not_nil assigns(:relationships)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:relationship)
    assert assigns(:relationship).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:relationship)
  end

  def test_create
    num_relationships = Relationship.count

    post :create, :relationship => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_relationships + 1, Relationship.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:relationship)
    assert assigns(:relationship).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Relationship.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Relationship.find(@first_id)
    }
  end
end
