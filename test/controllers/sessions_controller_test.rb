require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @session = create(:session)
  end

  test "should get index" do
    get sessions_url
    assert_response :success
  end

  test "should get new" do
    get new_session_url
    assert_response :success
  end

  test "should show session" do
    get session_url(@session)
    assert_response :success
  end

  test "should destroy session" do
    assert_difference("Session.count", -1) do
      delete session_url(@session)
    end

    assert_redirected_to sessions_url
  end
end
