class ContactType < ActiveRecord::Base
  belongs_to :default_responsible_user, :class_name => "User", :foreign_key => "default_responsible_user_id"
  belongs_to :default_responsible_department, :class_name => "Department", :foreign_key => "default_responsible_department_id"
  has_and_belongs_to_many :contact_forms
  
  validates_uniqueness_of :name
  validates_presence_of :default_responsible_user_id
end
