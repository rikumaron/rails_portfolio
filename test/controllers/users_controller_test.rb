require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get sign_in_process" do
    get users_sign_in_process_url
    assert_response :success
  end

end
