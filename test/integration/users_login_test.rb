require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user_f1)
  end

  test "login with valid email/invalid password" do
    get login_path(:html)
    assert_template "sessions/new"
    post login_path(:html), params: { session: { email: @user.email,
                                                password: "invalid" } }
    assert_not is_logged_in?
    assert_template "sessions/new"
    assert_not flash.empty?
  end

  test "login with valid information followed by logout" do
    get login_path(:html)
    post login_path(:html), params: { session: { email: @user.email,
                                                password: "test" } }
    assert is_logged_in?
    assert_redirected_to root_path
    follow_redirect!
    assert_template "home/index"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user, :html)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_redirected_to login_url
    follow_redirect!
    assert_template "sessions/new"
  end
end
