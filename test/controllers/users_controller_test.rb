require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    #@user1 = users(:one)

    @user_exist = User.create(
      name: "userexist",
      email: "userexist@test.org",
      password: "test",
      password_confirmation: "test",
      fullname: "User exists",
      is_admin: false,
    )

    @user = User.new(
      name: "usertest",
      email: "usertest@test.org",
      password: "test",
      password_confirmation: "test",
      fullname: "User test",
      is_admin: false,
    )
  end

  test "ok to test" do
    assert @user_exist.persisted?
  end

  test "should get index" do
    login_as_admin
    get users_url
    assert_response :success
  end

  test "should get new" do
    login_as_admin
    get new_user_url(:html)
    assert_response :success
  end

  test "should create user" do
    login_as_admin
    u = @user
    assert_difference("User.count") do
      post users_url(:html), params: {
                               user: {
                                 name: u.name,
                                 email: u.email,
                                 fullname: u.fullname,
                                 is_admin: u.is_admin,
                                 password: "test",
                                 password_confirmation: "test",
                               },
                             }
    end

    assert_redirected_to user_url(User.last, :html)
  end

  test "should show user" do
    login_as_admin
    get user_url(@user_exist)
    assert_response :success
  end

  test "should show user JSON" do
    login_as_admin
    get user_url(@user_exist, :json)
    assert_response :success
    r = JSON.parse @response.body
    assert r["name"] == @user_exist.name
  end

  test "should get edit" do
    login_as_admin
    get edit_user_url(@user_exist, :html)
    assert_response :success
  end

  test "should update user" do
    login_as_admin
    u = @user_exist
    patch user_url(u, :html), params: {
                                user: {
                                  email: u.email,
                                  fullname: u.fullname,
                                  is_admin: u.is_admin,
                                  name: u.name,
                                  password: "test",
                                  password_confirmation: "test",
                                },
                              }
    assert_redirected_to user_url(u, :html)
  end

  test "should destroy user" do
    login_as_admin
    assert_difference("User.count", -1) do
      delete user_url(@user_exist, :html)
    end

    assert_redirected_to users_url(:html)
  end
end
