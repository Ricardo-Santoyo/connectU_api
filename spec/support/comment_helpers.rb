require 'faker'
require 'factory_bot_rails'

module CommentHelpers

  def create_comment(user, post, type = "Post")
    FactoryBot.create(:comment, 
      body: Faker::Lorem.sentence,
      user_id: user.id,
      commentable_type: type,
      commentable_id: post.id
		)
  end

end