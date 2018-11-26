class NotifyNewMessageJob < ApplicationJob
  queue_as :default
  retry_on RuntimeError

  def perform(current_user, devices_id, message)
    NotificationService.new(current_user).notify_user(
      devices_id,
      I18n.t('api.messages.new_message'),
      message
    )
  end
end
