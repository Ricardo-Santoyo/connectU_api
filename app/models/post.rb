class Post < ApplicationRecord
  validates :body, presence: true
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  private

  def user_name
    return self.user.name
  end

  def user_handle
    return self.user.handle
  end
end
