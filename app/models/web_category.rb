class WebCategory < ActiveRecord::Base
  has_and_belongs_to_many :groups, :join_table => "groups_web_categories"
end
