require 'faker'
require 'factory_bot_rails'

module LikeHelpers

  def create_like(user, post)
    FactoryBot.create(:like,
      user_id: user.id,
      likeable_type: "Post",
      likeable_id: post.id
		)
  end

end