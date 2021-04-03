class Comment < ApplicationRecord
  validates :body, :user_id, :post_id, presence: true
  belongs_to :user
  belongs_to :post
  has_many :likes, as: :likeable, dependent: :destroy
  attr_accessor :uid

  private

  def user_name
    return self.user.name
  end

  def user_handle
    return self.user.handle
  end

  def like_count
    return self.likes.count
  end

  def like_id
    return self.likes.where(user_id:uid).ids.first
  end
end
