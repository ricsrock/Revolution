class Report < ActiveRecord::Base
  belongs_to :group_by, :class_name => "GroupBy", :foreign_key => "group_by_id"
  belongs_to :layout, :class_name => "Layout", :foreign_key => "layout_id"
  belongs_to :record_type, :class_name => "RecordType", :foreign_key => "record_type_id"
  
  serialize :parameters, String
  
  acts_as_stampable
  
  def self.accessible_to_user(user_id)
    user = User.find(user_id)
    if user.has_role?('admin') or user.has_role?('financial')
      where('1=1')
    else
      where('record_types.name != ?', 'Donation').includes(:record_type).references(:record_types)
    end
  end
  
  def model_name
    case self.record_type.name
    when "Tags"
      "Tagging"
    when "Contacts"
      "Contact"
    when "Contributions"
      "Donation"
    end
  end
  
  def search_params
    YAML::load(self.parameters)
  end
  
  def date_range
    if search_params.has_key?(:range_selector_cont)
      search_params[:range_selector_cont] + " (" + search_params[:start_date_gt].to_time.strftime('%x') + " - " + search_params[:start_date_lt].to_time.strftime('%x') + ")"
    else
      false
    end
  end
  
end
