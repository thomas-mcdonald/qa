User.create!(
  admin: true,
  email: Faker::Internet.email,
  name: 'Thomas McDonald'
)

100.times do
  User.create!(
    email: Faker::Internet.email,
    name: Faker::Name.name
  )
end