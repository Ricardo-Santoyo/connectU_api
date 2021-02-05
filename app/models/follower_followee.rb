class FollowerFollowee < ApplicationRecord
  validates :person_id, :follower_id, presence: true
  validates_uniqueness_of :follower_id, scope: :person_id 
  belongs_to :person, foreign_key: :person_id, class_name: 'User'
  belongs_to :follower, foreign_key: :follower_id, class_name: 'User'
end
