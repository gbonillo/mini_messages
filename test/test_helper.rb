ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  #parallelize(workers: :number_of_processors, with: :threads)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Returns true if a test user is logged in.
  def is_logged_in?
    !session[:user_id].nil?
  end

  def login_as_admin
    u = users(:admin)
    delete logout_url
    post login_url, params: { session: { email: u.email, password: "test" } }
    assert session[:user_id] == u.id
  end

  def login_as_user(user_fixture = :user_f1)
    u = users(user_fixture)
    delete logout_url
    post login_url, params: { session: { email: u.email, password: "test" } }
    assert session[:user_id] == u.id
  end

  def logout
    delete logout_url(:html)
    follow_redirect!
  end
end

module FixtureFileHelpers
  def digest(p)
    User.digest(p)
  end
end

ActiveRecord::FixtureSet.context_class.include FixtureFileHelpers
