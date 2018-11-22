json.conversations @conversations do |conversation|
  json.id conversation.id
  json.user_one do
    json.partial! 'api/v1/shared/user', user: conversation.user_one
  end
  json.user_two do
    json.partial! 'api/v1/shared/user', user: conversation.user_two
  end
  json.last_message do
    unless conversation.messages.empty?
      json.partial! 'api/v1/shared/message', message: conversation.messages.last
    end
  end
  json.messages_not_readed conversation.messages_not_readed?
end
