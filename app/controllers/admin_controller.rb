class AdminController < ApplicationController

  before_filter :authenticate if APP_CONFIG["authenticate"]

  private

  def authenticate
    users = { APP_CONFIG["username"] => APP_CONFIG["password"] }
    authenticate_or_request_with_http_digest do |username|
      users[username]
    end
  end
end