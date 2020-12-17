require "application_system_test_case"

class MessagesTest < ApplicationSystemTestCase
  setup do
    @message = messages(:message_simple)
  end

  test "visiting the index" do
    _login()
    visit messages_url
    assert_selector "h1", text: "Messages"
  end

  test "creating a Message" do
    _login()
    visit messages_url
    click_on "New Message"

    fill_in "Content", with: @message.content
    #fill_in "User", with: @message.user_id
    page.select @message.dest.name, from: "Dest"
    check "Is public" if @message.is_public
    click_on "Create Message"

    assert_text "Message was successfully created"
    click_on "Back"
  end

  test "reply to a Message" do
    _login(:user_f2)
    visit messages_url
    click_on "Show", match: :first
    click_on "Reply", match: :first

    fill_in "Content", with: "Reply"
    click_on "Reply"

    assert_text "Message was successfully created"
    click_on "Back"
  end

  test "destroying a Message" do
    _login(:user_f1)
    visit messages_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Message was successfully destroyed"
  end

  private

  def _login(user_fixture = :user_f1)
    # log in user session ...
    # visit root_url
    # begin
    #   if find("Log out")
    #     click_on "Log out"
    #   end
    # rescue Capybara::ElementNotFound => e
    #   # skip!
    # end
    @user = users(user_fixture)
    visit login_url(:html)
    fill_in "Email", with: @user.email
    fill_in "Password", with: "test"
    click_on "Log in", { class: "btn" }
  end
end
