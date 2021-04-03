class Like < ApplicationRecord
  validates :user_id, :likeable, presence: true
  validates_uniqueness_of :user_id, scope: :likeable 
  belongs_to :user
  belongs_to :likeable, polymorphic: true
end
