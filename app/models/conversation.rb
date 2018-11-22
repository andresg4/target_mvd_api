class Conversation < ApplicationRecord
  belongs_to :user_one, foreign_key: :user_one_id, class_name: 'User'
  belongs_to :user_two, foreign_key: :user_two_id, class_name: 'User'

  has_many :messages, dependent: :destroy

  validates_uniqueness_of :user_one_id, scope: :user_two_id

  validate :conversation_with_self

  def self.create_conversation_between(user_one_id, user_two_id)
    Conversation.where("(user_one_id = #{user_one_id} AND user_two_id = #{user_two_id}) \
    OR (user_one_id = #{user_two_id} AND user_two_id = #{user_one_id})")
                .first_or_create!(user_one_id: user_one_id, user_two_id: user_two_id)
  end

  def messages_not_readed?
    messages.any? { |message| !message.read } unless messages.empty?
  end

  private

  def conversation_with_self
    errors.add(:user_id, 'Must be different from current user id.') if user_one == user_two
  end
end
