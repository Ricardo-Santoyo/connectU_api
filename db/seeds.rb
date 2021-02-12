require 'faker'

n = 1

while n <= 20
  User.create(
    name: Faker::FunnyName.name, 
    email: Faker::Internet.email, 
    password: Faker::Internet.password
  )

  25.times do
    Post.create(
      body: Faker::Lorem.sentence,
      user_id: n
    )
  end
  n += 1
end