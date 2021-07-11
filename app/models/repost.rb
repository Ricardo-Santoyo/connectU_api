class Repost < ApplicationRecord
  validates :user_id, :repostable, presence: true
  validates_uniqueness_of :user_id, scope: :repostable
  belongs_to :user
  belongs_to :repostable, polymorphic: true

  include PostInfo
end
