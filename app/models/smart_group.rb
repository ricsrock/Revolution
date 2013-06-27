class SmartGroup < ActiveRecord::Base
  has_many :smart_group_rules, :class_name => "SmartGroupRule", :foreign_key => "smart_group_id", dependent: :destroy
  has_many :favorites, as: :favoritable
  has_many :fans, through: :favorites, :source => :user
  
  
  validates :name, presence: true
  validates :smart_group_rules, :length => { minimum: 1, message: "must be at least one"} 
  
  accepts_nested_attributes_for :smart_group_rules, reject_if: :all_blank, allow_destroy: true
  
  acts_as_stampable
  
  ransacker :favorites do |parent|
    nil
  end
  
  def result
    q = Person.all
    smart_group_rules.reject {|r| r.smart_group_property.short == "exclusive_tags"}.each do |r|
      q = q.where(r.clause)
    end
    smart_group_rules.select {|r| r.smart_group_property.short == "exclusive_tags"}.each do |r|
      q = q.joins(r.clause)
    end
    q = q.includes(:groups, :tags, :attendance_trackers, :household)
    q.uniq
  end
  
  def number_found
    result.length
  end
  
  def favorite?(user)
    self.fan_ids.include?(user.id)
  end
  
  def self.favorites_for(user)
    where('favorites.favoritable_type = ? AND favorites.user_id = ?', 'SmartGroup', user.id).joins(:favorites)
  end
  
  def self.fix_params(params_hash)
    if params_hash[:favorites_eq].blank?
      logger.info "range selector is blank"
      params_hash
    else
      logger.info "favorites_eq has value: #{params_hash[:favorites_eq]}"
      range_name = params_hash[:range_selector_cont]
      params_hash = params_hash.except!(:range_selector)
      params_hash.merge!(created_at_gt: do_range(range_name).start_date.to_time)
      params_hash.merge!(created_at_lt: do_range(range_name).end_date.to_time)
      params_hash
    end
  end
    
end
