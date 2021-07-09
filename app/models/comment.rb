class Comment < ApplicationRecord
  validates :body, :user_id, :commentable, presence: true
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  attr_accessor :uid

  private

  def user_name
    return self.user.name
  end

  def user_handle
    return self.user.handle
  end
 
  def comment_count
    return self.comments.count
  end

  def commented
    return self.comments.exists?(user_id:uid)
  end

  def like_count
    return self.likes.count
  end

  def like_id
    return self.likes.where(user_id:uid).ids.first
  end

  def user_post_id
    return self.user.comments.find_index(self) + 1
  end
end
