class NotifyNewMessageJob < ApplicationJob
  queue_as :default
  retry_on RuntimeError

  def perform(current_user, devices_id, message)
    NotificationService.new(current_user).notify_user(
      devices_id,
      'You have a new message',
      message
    )
  end
end
