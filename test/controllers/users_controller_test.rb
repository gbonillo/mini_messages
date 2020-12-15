require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    #@user1 = users(:one)

    @user_exist = User.create(
      name: "userexist",
      email: "userexist@test.org",
      password_digest: User.password_hash("test"),
      fullname: "User exists",
      is_admin: false,
    )

    @user = User.new(
      name: "usertest",
      email: "usertest@test.org",
      password_digest: User.password_hash("test"),
      fullname: "User test",
      is_admin: false,
    )
  end

  test "ok to test" do
    assert @user_exist.persisted?
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      u = @user
      post users_url, params: {
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

    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    get user_url(@user_exist)
    assert_response :success
  end

  test "should show user JSON" do
    get user_url(@user_exist) + ".json"
    assert_response :success
    r = JSON.parse @response.body
    assert r["name"] == @user_exist.name
  end

  test "should get edit" do
    get edit_user_url(@user_exist)
    assert_response :success
  end

  test "should update user" do
    u = @user_exist
    patch user_url(u), params: {
                         user: {
                           email: u.email,
                           fullname: u.fullname,
                           is_admin: u.is_admin,
                           name: u.name,
                           password: "test",
                           password_confirmation: "test",
                         },
                       }
    assert_redirected_to user_url(u)
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete user_url(@user_exist)
    end

    assert_redirected_to users_url
  end
end
