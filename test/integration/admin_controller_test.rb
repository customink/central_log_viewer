require 'test_helper'

class AdminControllerTest < ActionController::IntegrationTest

  test "should redirect when authentication is enabled" do
    APP_CONFIG["authenticate"] = true
    get '/log/apps'
    assert_response 401
  end

  test "should not redirect when authentication is not enabled" do
    APP_CONFIG["authenticate"] = false
    get '/log/apps'
    assert_response 200
  end

end