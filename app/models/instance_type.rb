class InstanceType < ActiveRecord::Base
  has_many :auto_instance_types
  has_many :event_types, through: :auto_instance_types
  has_many :auto_groups
  has_many :groups, -> { order('groups.name ASC') }, through: :auto_groups
  has_many :instances, dependent: :restrict_with_exception
  
  validates :start_time, :presence => true
  
  def start_time=(start_time)
    t = start_time.to_time
    self[:start_time] = t.change(year: 2000, month: 1, day: 1)
  end
  
  def available_groups
    Group.all(:conditions => ['groups.id NOT IN
                                  (SELECT auto_groups.group_id FROM auto_groups
                                  WHERE (auto_groups.instance_type_id = ?))', self.id], :order => :name)
  end
  
  def starts_at
    if ! start_time.blank?
      start_time.to_time.strftime("%l:%M%P")
    else
      ''
    end  
  end
  
  def type_id
    'instance_type_' + id.to_s
  end
  
end
