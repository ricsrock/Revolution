require File.dirname(__FILE__) + '/../test_helper'
require 'note_types_controller'

# Re-raise errors caught by the controller.
class NoteTypesController; def rescue_action(e) raise e end; end

class NoteTypesControllerTest < Test::Unit::TestCase
  fixtures :note_types

  def setup
    @controller = NoteTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = note_types(:first).id
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

    assert_not_nil assigns(:note_types)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:note_type)
    assert assigns(:note_type).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:note_type)
  end

  def test_create
    num_note_types = NoteType.count

    post :create, :note_type => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_note_types + 1, NoteType.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:note_type)
    assert assigns(:note_type).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      NoteType.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      NoteType.find(@first_id)
    }
  end
end
