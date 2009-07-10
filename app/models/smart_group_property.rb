class SmartGroupProperty < ActiveRecord::Base
  has_many :operators
  has_many :smart_group_rules
  
  validates_uniqueness_of :short
  
  def self.find_allowed(user_id)
    user = User.find(user_id)
    @properties = find(:all)
    if ! user.has_role?("financials")
      @properties = @properties.reject {|p| p.prose.include? "contribution" }
    end
    @properties
  end
  
end
