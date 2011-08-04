class AdminController < ApplicationController

  USERS = { APP_CONFIG["username"] => APP_CONFIG["password"] }

  before_filter :authenticate if APP_CONFIG["is_enabled"]

  private

  def authenticate
    authenticate_or_request_with_http_digest do |username|
      USERS[username]
    end
  end
end