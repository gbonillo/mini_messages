require "test_helper"

class MessageTest < ActiveSupport::TestCase
  def setup
    @message = messages(:message_simple)
    @message2 = messages(:message_simple2)
  end

  test "simple message should be valid" do
    assert @message.valid?
  end

  test "message without author should NOT be valid" do
    @message.author = nil
    assert_not @message.valid?
    @message2.user_id = nil
    assert_not @message2.valid?
  end

  test "message without dest should NOT be valid" do
    @message.dest = nil
    assert_not @message.valid?
    @message2.dest_id = nil
    assert_not @message2.valid?
  end

  test "message without content should NOT be valid" do
    @message.content = nil
    assert_not @message.valid?
    @message.content = ""
    assert_not @message.valid?
    @message.content = "    "
    assert_not @message.valid?
  end

  test "email are escaped in content on validation" do
    NB_MAIL = 10 # nb d'email à trouver dans le texte ci-dessous
    mails = <<-END_MAIL
      Start
      test.again.WhyNot123@inca.com
      pio_pio@factory.com Blah
      carnival666@hellmail.com
      la-lalai@gmail.com
      testmail@mail.com
      .testmail@mail.com
      testmail@mail.com.
      testm ail@mail.com
      testmail@mail.com.de
      testmail@mail.de.org
      End
      END_MAIL

    @message.content = mails
    assert @message.valid?
    nb = @message.content.scan(Message::DEFAULT_CONTENT_REPLACE).count
    #byebug
    assert nb == NB_MAIL
  end

  test "tel num are escaped in content on validation" do
    NB_TEL = 7 # nb de tel à trouver dans le texte ci-dessous
    tels = <<-END_TEL
      Start06 01 02 03 04
      +33 6 01 02 03 04
      0033 7 01 02 03 04
      06.01.02.03.55
      06.01.02.03.55
      06-01-02-03-55
      06  01  02  03  04End
      END_TEL

    @message.content = tels
    assert @message.valid?
    nb = @message.content.scan(Message::DEFAULT_CONTENT_REPLACE).count
    assert nb == NB_TEL
  end
end
