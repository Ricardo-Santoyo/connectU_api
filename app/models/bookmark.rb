class Bookmark < ApplicationRecord
  validates :user_id, :bookmarkable, presence: true
  validates_uniqueness_of :user_id, scope: :bookmarkable
  belongs_to :user
  belongs_to :bookmarkable, polymorphic: true
end
