require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get login_path
    assert_response :success
  end
end
