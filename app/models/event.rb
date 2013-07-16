class Event < ActiveRecord::Base
  belongs_to :event_type, :class_name => "EventType", :foreign_key => "event_type_id"
  
  has_many :instances, dependent: :destroy
  has_many :meetings, through: :instances
  has_many :attendances, through: :meetings
  has_many :uniq_people, -> { uniq }, through: :attendances, source: :person
  
  validates :event_type_id, :date, :presence => true
  validates :date, uniqueness: { scope: :event_type_id, message: "You already have an event of this type on this date." }
  
  before_save :set_name
  after_create :auto_create_instances
  
  acts_as_stampable
  
  ransacker :range_selector do |parent|
    nil
  end
  
  def self.fix_params(params_hash)
    if params_hash[:range_selector_cont].blank?
      logger.info "range selector is blank"
      params_hash
    else
      logger.info "range selector has value: #{params_hash[:range_selector]}"
      range_name = params_hash[:range_selector_cont]
      params_hash = params_hash.except!(:range_selector)
      params_hash.merge!(date_gt: do_range(range_name).start_date.to_time.to_s(:db))
      params_hash.merge!(date_lt: do_range(range_name).end_date.to_time.to_s(:db))
      params_hash
    end
  end
  
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
