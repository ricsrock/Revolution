require 'test_helper'

class AttendancesControllerTest < ActionController::TestCase
  setup do
    @attendance = attendances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:attendances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create attendance" do
    assert_difference('Attendance.count') do
      post :create, attendance: { call_number: @attendance.call_number, checkin_time: @attendance.checkin_time, checkin_type_id: @attendance.checkin_type_id, checkout_time: @attendance.checkout_time, meeting_id: @attendance.meeting_id, person_id: @attendance.person_id, security_code: @attendance.security_code }
    end

    assert_redirected_to attendance_path(assigns(:attendance))
  end

  test "should show attendance" do
    get :show, id: @attendance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @attendance
    assert_response :success
  end

  test "should update attendance" do
    patch :update, id: @attendance, attendance: { call_number: @attendance.call_number, checkin_time: @attendance.checkin_time, checkin_type_id: @attendance.checkin_type_id, checkout_time: @attendance.checkout_time, meeting_id: @attendance.meeting_id, person_id: @attendance.person_id, security_code: @attendance.security_code }
    assert_redirected_to attendance_path(assigns(:attendance))
  end

  test "should destroy attendance" do
    assert_difference('Attendance.count', -1) do
      delete :destroy, id: @attendance
    end

    assert_redirected_to attendances_path
  end
end
