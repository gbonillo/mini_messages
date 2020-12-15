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
    delete logout_url
    post login_url, params: { session: { email: "admin_f1@test.org", password: "test" } }
    assert session[:user_id] == User.find_by(email: "admin_f1@test.org").id
  end

  def login_as_user
    delete logout_url
    post login_url, params: { session: { email: "user_f1@test.org", password: "test" } }
    assert_response :success
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
