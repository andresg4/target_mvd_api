class NotifyMatchTargetJob < ApplicationJob
  queue_as :default
  retry_on RuntimeError

  def perform(current_user, devices_id)
    new_match_message = I18n.t('api.messages.new_match')
    NotificationService.new(current_user).notify_user(
      devices_id,
      new_match_message,
      new_match_message
    )
  end
end
