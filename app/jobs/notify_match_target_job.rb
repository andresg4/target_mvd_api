class NotifyMatchTargetJob < ApplicationJob
  queue_as :default
  retry_on RuntimeError

  def perform(current_user, devices_id)
    NotificationService.new(current_user).notify_user(
      devices_id,
      'You have a new match',
      'You have a new match'
    )
  end
end
