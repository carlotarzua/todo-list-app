require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get "/users/sign_in"
    assert_response :success
  end
end
