class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
  
  validates :name, :email, :password, presence: true
  validates :handle, uniqueness: true
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :followers, foreign_key: :person_id, class_name: 'FollowerFollowee', dependent: :destroy
  has_many :following, foreign_key: :follower_id, class_name:'FollowerFollowee', dependent: :destroy
  attr_accessor :uid

  before_create :create_unique_handle

  def follower_followee_id
    return self.followers.where(follower_id:uid).ids.first
  end

  private 

  def create_unique_handle
    loop do
      self.handle = SecureRandom.alphanumeric(15)
      break unless self.class.exists?(:handle => handle)
    end
  end
end
