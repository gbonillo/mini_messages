json.messages_url messages_url(:json)
if logged_in?
  json.current_user do
    json.extract! current_user, :id, :name
  end
end
