require 'faker'
require 'factory_bot_rails'

module RepostHelpers

  def create_repost(user, post, type = "Post")
    FactoryBot.create(:repost,
      user_id: user.id,
      repostable_type: type,
      repostable_id: post.id
		)
  end

end