class Post < ApplicationRecord
  validates :body, presence: true
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :reposts, as: :repostable, dependent: :destroy
  
  include PostInfo
end
