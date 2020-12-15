require "application_system_test_case"

class UsersAdminTest < ApplicationSystemTestCase
  setup do
    #@user = users(:one)
    @user = User.new(
      name: "usertest",
      email: "usertest@test.org",
      password: "test",
      password_confirmation: "test",
      fullname: "User test",
      is_admin: false,
    )

    # log in admin session ...
    admin = User.find_by(email: "admin_f1@test.org")
    visit login_url(:html)
    fill_in "Email", with: admin.email
    fill_in "Password", with: "test"
    click_on "Log in", { class: "btn" }
  end

  test "visiting the users list" do
    visit users_url(:html)
    assert_selector "h1", text: "Users"
  end

  test "creating a User" do
    visit users_url(:html)
    click_on "New User"

    fill_in "Email", with: @user.email
    fill_in "Fullname", with: @user.fullname
    check "Is admin" if @user.is_admin
    fill_in "Name", with: @user.name
    fill_in "Password", with: @user.password
    fill_in "Password confirmation", with: @user.password_confirmation
    click_on "Create User"

    assert_text "User was successfully created"
    click_on "Users"
  end

  test "updating a User" do
    visit users_url(:html)
    click_on "Edit", match: :first

    fill_in "Email", with: @user.email
    fill_in "Fullname", with: @user.fullname
    check "Is admin" if @user.is_admin
    fill_in "Name", with: @user.name
    fill_in "Password", with: @user.password
    fill_in "Password confirmation", with: @user.password_confirmation
    click_on "Update User"

    assert_text "User was successfully updated"
    click_on "Users"
  end

  test "destroying a User" do
    visit users_url(:html)
    page.accept_confirm do
      btn = page.all("a", text: "Destroy").last
      btn.click
    end

    assert_text "User was successfully destroyed"
  end
end
