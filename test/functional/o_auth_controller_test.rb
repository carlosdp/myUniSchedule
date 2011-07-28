require 'test_helper'

class OAuthControllerTest < ActionController::TestCase
  test "should get redirect" do
    get :redirect
    assert_response :success
  end

end
