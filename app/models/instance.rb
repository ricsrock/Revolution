class Instance < ActiveRecord::Base
  belongs_to :instance_type, :class_name => "InstanceType", :foreign_key => "instance_type_id"
  belongs_to :event, :class_name => "Event", :foreign_key => "event_id"
  
  has_many :meetings
  has_many :attendances, through: :meetings
  
  validates :instance_type_id, :event_id, :presence => true
  
  after_create :auto_create_meetings
  
  def auto_create_meetings
    self.instance_type.auto_groups.each do |autogroup|
      @meeting = Meeting.new(:instance_id => self.id,
                             :group_id => autogroup.group.id,
                             :room_id => autogroup.group.default_room_id)
      @meeting.save
    end
  end
  
  def self.current # you can be 30 minutes late and still be checked into first service... after that, you get checked into 2nd service
    event = Event.where('date >= ?', Time.zone.now.to_date.to_s(:db)).order('date ASC').first
    instance = event.instances.select {|i| i.starts_at >= Time.zone.now - 30.minutes}.sort_by(&:starts_at).first # this needs to set to the instance that starts next or most recently
    if instance
      instance
    else
      event = Event.where('date > ?', Time.zone.now.to_date.to_s(:db)).order('date ASC').first
      instance = event.instances.select {|i| i.starts_at >= Time.zone.now - 30.minutes}.sort_by(&:starts_at).first # this needs to set to the instance that starts next or most recently
    end
  end
  
  def starts_at
    (self.event.date.to_s(:db) + " " + self.instance_type.starts_at.to_s).to_time
  end
  
  def available_groups
    Group.where('groups.id NOT IN
                (SELECT meetings.group_id FROM meetings
                WHERE (meetings.instance_id = ?)) AND
                (groups.checkin_group = ?)', self.id, true).order(:name)
  end
  
  def present_people_ids
    self.attendances.collect {|a| a.person_id}
  end
  
  def self.find_by_instance_type_name(name)
    Instance.where('instance_types.name LIKE ?', name).includes(:instance_type).references(:instance_type)
  end
  


end
