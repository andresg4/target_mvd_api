class MatchService
  def initialize(user, matched_targets)
    @user = user
    @targets = matched_targets
  end

  def create_conversations
    @targets.each do |target|
      Conversation.create_conversation_between(@user.id, target.user.id)
    end
  end
end
