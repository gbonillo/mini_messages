class MessagesDeleteOldJob < ApplicationJob
  queue_as :default

  DELAY_BEFORE_DELETE = 3.months

  def perform(*args)
    limit_delete = Time.now - DELAY_BEFORE_DELETE

    Message.all.is_root.where(
      "created_at < :limit_delete",
      :limit_delete => limit_delete,
    ).destroy_all
  end
end
