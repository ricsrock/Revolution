class SmallGroup < Group
  STATUSES = %w[Active Archived All]
  
  has_many :primary_leaderships, :as => :leadable, dependent: :destroy
  has_many :support_leaderships, :as => :leadable, dependent: :destroy
  
  belongs_to :cadence
  
  # has_one :frequency
  
  validates :inquiry_number, :uniqueness => true, if: proc { |a| a.inquiry_number.present? }
  
  
  accepts_nested_attributes_for :primary_leaderships, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :support_leaderships, reject_if: :all_blank, allow_destroy: true
  # accepts_nested_attributes_for :frequency, reject_if: :all_blank, allow_destroy: true
  
  
  ransacker :archived_yes do |parent|
    nil
  end
  
  ransacker :active, :formatter => proc {|v| v == "1" ? Time.zone.now.to_s(:db) : nil } do |parent|
    Arel::Nodes::Or.new(Arel::Nodes::SqlLiteral.new('IS NULL'), Arel::Nodes::GreaterThan.new(parent.table[:archived_at], ' '))
  end
  
  ransacker :namey, :formatter => proc {|v| v.downcase} do |parent|
    Arel::Nodes::GreaterThan.new(parent.table[:name], ' ')
    # parent.table[:name]
  end
  
  ransacker :status do |parent|
    nil
  end
  
  def self.active
    where('groups.archived_at IS NULL OR groups.archived_at > ?', Time.zone.now.to_s(:db))
  end
  
  def self.archived
    where('groups.archived_at IS NOT NULL AND groups.archived_at < ?', Time.zone.now.to_s(:db))
  end
  
  def self.inquirable
    where('groups.inquiry_number IS NOT NULL').order(:inquiry_number)
  end
  
  def self.status(params_hash)
    if params_hash && params_hash[:status_cont]
      logger.info "status_cont is in the params_hash: #{params_hash[:status_cont]}"
      value = params_hash[:status_cont]
    else
      logger.info "status_cont is not in the params_hash: #{params_hash}"
      value = 'Active'
    end
    case value
    when 'Active'
      self.active
    when 'Archived'
      self.archived
    when 'All'
      self
    else
      self
    end
  end
  
  def self.fix_params(params_hash)
    if params_hash[:archived_yes_cont] == "0"
      logger.info "archived_yes_cont is '0'"
      params_hash
    else
      logger.info "archived yes has value: #{params_hash[:archived_yes_cont]}"
      # range_name = params_hash[:range_selector_cont]
      params_hash = params_hash.except!(:archived_yes_cont)
      params_hash.merge!(archived_at_present: true)
      params_hash.merge!(archived_at_before_today: "1")
      # params_hash.merge!(created_at_gt: do_range(range_name).start_date.to_time.to_s(:db))
      # params_hash.merge!(created_at_lt: do_range(range_name).end_date.to_time.to_s(:db))
      params_hash
    end
  end
  
  def reset_inquiry_number!
    self.update_attribute(:inquiry_number, nil)
  end
    
end