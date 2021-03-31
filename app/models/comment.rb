class Comment < ApplicationRecord
  validates :body, :user_id, :post_id, presence: true
  belongs_to :user
  belongs_to :post
  attr_accessor :uid

  private

  def user_name
    return self.user.name
  end

  def user_handle
    return self.user.handle
  end
end
