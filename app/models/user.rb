class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
  
  validates :name, :email, :password, presence: true
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
end
