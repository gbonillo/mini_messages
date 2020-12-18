if (!in_list && (is_admin? || is_current_user?(user)))
  json.extract! user, :id, :name, :email, :fullname, :is_admin, :created_at, :updated_at
  json.url user_url(user, format: :json)
else
  json.extract! user, :id, :name
end
