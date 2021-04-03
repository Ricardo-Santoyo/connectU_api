class Post < ApplicationRecord
  validates :body, presence: true
  belongs_to :user
  has_many :comments, dependent: :destroy
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

  def like_count
    return self.likes.count
  end

  def like_id
    return self.likes.where(user_id:uid).ids.first
  end
end
