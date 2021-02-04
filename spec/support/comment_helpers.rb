require 'faker'
require 'factory_bot_rails'

module CommentHelpers

  def create_comment(user, post)
    FactoryBot.create(:comment, 
      body: Faker::Lorem.sentence,
      user_id: user.id,
      post_id: post.id
		)
  end

end