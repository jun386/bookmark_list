# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(
  name: "test1",
  email: "test1@example.com",
  password: "password"
)

User.create!(
  name: "test2",
  email: "test2@example.com",
  password: "password"
)

10.times do
  Bookmark.create(
    title: Faker::Lorem.word,
    url: Faker::Internet.url,
    category: Faker::Lorem.word,
    user_id: 1
  )
end