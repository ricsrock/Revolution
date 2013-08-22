class Weekday < ActiveRecord::Base
  validates :name, :uniqueness =>  true
end
