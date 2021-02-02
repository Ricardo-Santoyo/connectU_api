require 'faker'
require 'factory_bot_rails'

module UserHelpers

  def create_user
    FactoryBot.create(:user, 
      name: Faker::FunnyName.name,
			email: Faker::Internet.email, 
			password: Faker::Internet.password
		)
  end

	def build_user
    FactoryBot.build(:user, 
      name: Faker::FunnyName.name,
			email: Faker::Internet.email, 
			password: Faker::Internet.password
		)
  end

end