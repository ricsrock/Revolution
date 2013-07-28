class Call < ActiveRecord::Base
  validates :from, :to, :sid, :presence => true
end
