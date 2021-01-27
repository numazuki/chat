# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
20.times do |index|
  no = index + 1
  user = User.create(
    name: "test_#{no}",
    email: "test_#{no}@example.com",
    password: "#{no}password#{no}",
    password_confirmation: "#{no}password#{no}",
    profile: "test_____%#{no}",
    search_id: "test_#{no}"
  )
  user.save!
end
