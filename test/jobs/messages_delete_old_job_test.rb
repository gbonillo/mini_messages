require "test_helper"

class MessagesDeleteOldJobTest < ActiveJob::TestCase
  test "messages ares purged correctly" do
    delay = MessagesDeleteOldJob::DELAY_BEFORE_DELETE + 1.hour

    m = messages(:message_simple) # should be purged

    _create_copy = -> {
      Message.create!(
        content: m.content,
        author: m.author,
        dest: m.dest,
        is_public: m.is_public,
      )
    }

    m2 = nil # should NOT be purged
    m3 = nil # should NOT be purged

    travel (delay / 2) do
      m2 = _create_copy.call()
    end

    travel delay do
      m3 = _create_copy.call()

      assert_changes "Message.count" do
        MessagesDeleteOldJob.perform_now()
      end
    end

    assert Message.find_by(id: m.id).blank?
    assert_not Message.find_by(id: m2.id).blank?
    assert_not Message.find_by(id: m3.id).blank?
  end
end
