json.extract! user, :id, :name, :email, :fullname, :is_admin, :created_at, :updated_at
json.url user_url(user, format: :json)
