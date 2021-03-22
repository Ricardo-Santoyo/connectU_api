require 'faker'
require 'factory_bot_rails'

module FollowerFolloweeHelpers

  def create_follower_followee(user1, user2)
    FactoryBot.create(:follower_followee,
      person_id: user1.id,
      follower_id: user2.id
		)
  end

end