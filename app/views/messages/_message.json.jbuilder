#json.extract! message, :id, :content, :user_id, :dest_id, :is_public, :created_at, :updated_at
json.extract! message, :id, :content, :is_public, :created_at, :updated_at
[:author, :dest].each do |attr|
  json.set! attr do
    json.extract! message.send(attr), :id, :name
  end
end
json.replies do
  json.array! message.replies.visible(current_user), partial: "messages/message", as: :message
end
json.url message_url(message, format: :json)
