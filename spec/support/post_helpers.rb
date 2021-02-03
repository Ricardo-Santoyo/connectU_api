require 'faker'
require 'factory_bot_rails'

module PostHelpers

  def create_post(user)
    FactoryBot.create(:post, 
      body: Faker::String.random.gsub("\u0000", ''),
      user_id: user.id
		)
  end

end