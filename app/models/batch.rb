class Batch < ActiveRecord::Base
  has_many :contributions, dependent: :restrict_with_exception #TODO: Account for this in the controller... needs a rescue
  has_many :donations, through: :contributions
  
  validates :date_collected, :count_total, :contributions_num, :presence => true
  
  acts_as_stampable
  
  
  ransacker :range_selector do |parent|
    nil
  end
  
  
  # ransacker :range_name, formatter: proc { |terms| Range.new(2,8).to_a }, splat_params: true do |parent|
  #   parent.table[:date_collected]
  # end  
  
  def amount_recorded
    self.contributions.sum(:total)
  end
  
  def self.fix_params(params_hash)
    if params_hash[:range_selector_cont].blank?
      logger.info "range selector is blank"
      params_hash
    else
      logger.info "range selector has value: #{params_hash[:range_selector]}"
      range_name = params_hash[:range_selector_cont]
      params_hash = params_hash.except!(:range_selector)
      params_hash.merge!(date_collected_gt: do_range(range_name).start_date.to_time.to_s(:db))
      params_hash.merge!(date_collected_lt: do_range(range_name).end_date.to_time.to_s(:db))
      params_hash
    end
  end
  
end
