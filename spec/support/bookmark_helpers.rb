require 'faker'
require 'factory_bot_rails'

module BookmarkHelpers

  def create_bookmark(user, post, type = "Post")
    FactoryBot.create(:bookmark,
      user_id: user.id,
      bookmarkable_type: type,
      bookmarkable_id: post.id
		)
  end

end