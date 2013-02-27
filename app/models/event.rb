class Event < ActiveRecord::Base
  belongs_to :event_type, :class_name => "EventType", :foreign_key => "event_type_id"
  
  has_many :instances, dependent: :destroy
  has_many :meetings, through: :instances
  
  validates :event_type_id, :date, :presence => true
  validates :date, uniqueness: { scope: :event_type_id, message: "You already have an event of this type on this date." }
  
  before_save :set_name
  after_create :auto_create_instances
  
  def set_name
    self.name = "#{self.event_type.name}" + " (" "#{self.date}" + ")" if self.name.blank?
  end
  
  def auto_create_instances
    self.event_type.auto_instance_types.each do |i|
      @instance = Instance.new(:event_id => self.id,
                               :instance_type_id => i.instance_type_id)
      @instance.save
    end
  end
  
end
