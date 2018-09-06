ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def login_as(user)
    post login_url, params: {username: user.username, password: user.username}
  end

  def logout
    get logout_url
  end

  def setup
    puts "user ist: #{users(:jutta_user)}"
    login_as users(:jutta_user)
  end

end
