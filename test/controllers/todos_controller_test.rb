require "test_helper"

class TodosControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_todo_url
    assert_response :success
  end

  test "should create todo" do
    post todos_url, params: { to_do: { title: "Test Title", description: "Test Description", due_date: "2024-09-30" } }
    assert_response :redirect
  end
end
