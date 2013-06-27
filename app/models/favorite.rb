class Favorite < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :favoritable, polymorphic: true
  
  validates :user_id, presence: true,
            uniqueness: { scope: [:favoritable_id, :favoritable_type], message: "item is already in favorites list." }
  validates :favoritable_id, presence: true,
            :uniqueness => { scope: [:user_id, :favoritable_type], message: "item is already in favorites list." }
  validates :favoritable_type, presence: true,
            uniqueness: { scope: [:favoritable_id, :user_id], message: "item is already in favorites list." }  
            
  acts_as_stampable
  
end
