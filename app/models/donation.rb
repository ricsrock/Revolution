class Donation < ActiveRecord::Base
  belongs_to :fund, :class_name => "Fund", :foreign_key => "fund_id"
  belongs_to :contribution, :class_name => "Contribution", :foreign_key => "contribution_id"
  
  #validates :fund_id, :contribution_id, :presence => true
  
  after_save :total_contribution
  
  acts_as_stampable
  
  ransacker :range_selector do |parent|
    nil
  end
  
  def self.fund_id(id)
    where('donations.fund_id = ?', id)
  end
  
  def self.magic_includes
    Donation
  end
  
  def total_contribution
    self.contribution.update_attribute(:total, self.contribution.donations.sum(:amount))
  end
  
  def self.fix_params(params_hash)
    if params_hash[:range_selector_cont].blank?
      logger.info "range selector is blank"
      params_hash
    else
      logger.info "range selector has value: #{params_hash[:range_selector]}"
      range_name = params_hash[:range_selector_cont]
      params_hash = params_hash.except!(:range_selector)
      params_hash.merge!(contribution_date_gt: do_range(range_name).start_date.to_time)
      params_hash.merge!(contribution_date_lt: do_range(range_name).end_date.to_time)
      params_hash
    end
  end
  
end
