require "application_system_test_case"

class UsersSimpleTest < ApplicationSystemTestCase
  setup do

    # log in user session ...
    @user = User.find_by(email: "user_f1@test.org")
    visit login_url(:html)
    fill_in "Email", with: @user.email
    fill_in "Password", with: "test"
    click_on "Log in", { class: "btn" }
  end

  test "visiting the index" do
    visit root_url(:html)
    assert_selector "a", text: "Profile"
  end

  test "View and Edit own profil" do
    visit root_url(:html)
    click_on "Profile"

    assert_text "Name:"
    assert_text @user.name

    click_on "Edit"

    fill_in "Email", with: @user.email
    fill_in "Fullname", with: @user.fullname
    check "Is admin" if @user.is_admin
    fill_in "Name", with: @user.name
    fill_in "Password", with: "test"
    fill_in "Password confirmation", with: "test"
    click_on "Update User"

    assert_text "User was successfully updated."
  end
end
