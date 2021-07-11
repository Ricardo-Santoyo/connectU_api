class Comment < ApplicationRecord
  validates :body, :user_id, :commentable, presence: true
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :reposts, as: :repostable, dependent: :destroy

  include PostInfo

  def user_post_id
    return self.user.comments.find_index(self) + 1
  end
end
