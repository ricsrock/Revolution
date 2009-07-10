require File.dirname(__FILE__) + '/../test_helper'
require 'relationship_roles_controller'

# Re-raise errors caught by the controller.
class RelationshipRolesController; def rescue_action(e) raise e end; end

class RelationshipRolesControllerTest < Test::Unit::TestCase
  fixtures :relationship_roles

  def setup
    @controller = RelationshipRolesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = relationship_roles(:first).id
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

    assert_not_nil assigns(:relationship_roles)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:relationship_role)
    assert assigns(:relationship_role).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:relationship_role)
  end

  def test_create
    num_relationship_roles = RelationshipRole.count

    post :create, :relationship_role => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_relationship_roles + 1, RelationshipRole.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:relationship_role)
    assert assigns(:relationship_role).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      RelationshipRole.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      RelationshipRole.find(@first_id)
    }
  end
end
