require 'message_broadcast.rb'

class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates_presence_of :body

  validate :user_participates_conversation

  after_create_commit { MessageBroadcastJob.perform_now(self) }

  private

  def user_participates_conversation
    errors.add(:user, I18n.t('api.messages.create.invalid_user')) unless [conversation&.user_one,
                                                                          conversation&.user_two]
                                                                         .include?(user)
  end
end
