require 'message_broadcast.rb'

class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates_presence_of :body

  validate :user_participates_conversation

  after_create_commit do
    MessageBroadcastJob.perform_now(self)
    notify_new_message
  end

  private

  def user_participates_conversation
    errors.add(:user, I18n.t('api.messages.create.invalid_user')) unless [conversation&.user_one,
                                                                          conversation&.user_two]
                                                                         .include?(user)
  end

  def notify_new_message
    user_one = conversation.user_one
    user == user_one ? notify_user(conversation.user_two) : notify_user(user_one)
  end

  def notify_user(notified_user)
    NotifyNewMessageJob.perform_later(
      user,
      notified_user.devices.pluck(:device_id),
      body
    )
  end
end
