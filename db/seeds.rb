# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(
  name: "admin",
  email: "admin@test.org",
  fullname: "Admin User",
  password: "test",
  password_confirmation: "test",
  is_admin: true,
)

users = []
(1..10).each do |i|
  users << User.create(
    name: "user#{i}",
    email: "user#{i}@test.org",
    fullname: "User #{i}",
    password: "test",
    password_confirmation: "test",
  )
end

m = Message.create(
  content: "Test message root!",
  user_id: users[0].id,
  dest_id: users[1].id,
  is_public: true,
)

m1 = Message.create(
  content: "Test message reply 1!",
  user_id: users[1].id,
  dest_id: users[0].id,
  mparent_id: m.id,
  #mroot_id: m.id,
  is_public: true,
)
m2 = Message.create(
  content: "Test message reply 2!",
  user_id: users[2].id,
  dest_id: users[0].id,
  mparent_id: m.id,
  #mroot_id: m.id,
  is_public: true,
)
m1_1 = Message.create(
  content: "Test message reply 1 to 1!",
  user_id: users[0].id,
  dest_id: users[1].id,
  mparent_id: m1.id,
  #mroot_id: m.id,
  is_public: true,
)
m1_2 = Message.create(
  content: "Test message reply 2 to 1!",
  user_id: users[3].id,
  dest_id: users[1].id,
  mparent_id: m1.id,
  #mroot_id: m.id,
  is_public: false,
)
