class Tagging < ActiveRecord::Base
  belongs_to :tag, :class_name => "Tag", :foreign_key => "tag_id"
  belongs_to :tag_group, :class_name => "TagGroup", :foreign_key => "tag_group_id"
  belongs_to :person, :class_name => "Person", :foreign_key => "person_id"
  
  validates :tag_id, :person_id, :start_date, :presence => true
  
  # attr_accessor :tag_group_id
  
  acts_as_stampable
  
  before_validation(on: :create) do
    self.start_date ||= Date.today
    self.tag_group_id = self.tag.tag_group.id
  end
  
  ransacker :range_selector do |parent|
    nil
  end
  
  def self.fix_params(params_hash)
    if params_hash[:range_selector_cont].blank?
      logger.info "range selector is blank"
      params_hash
    else
      logger.info "range selector has value: #{params_hash[:range_selector_cont]}"
      range_name = params_hash[:range_selector_cont]
      params_hash = params_hash.except!(:range_selector_cont)
      params_hash.merge!(start_date_gt: do_range(range_name).start_date.to_time.to_s(:db))
      params_hash.merge!(start_date_lt: do_range(range_name).end_date.to_time.to_s(:db))
      params_hash
    end
  end
  
  def self.magic_includes
    Tagging
  end
  
  def full_name
    tag.tag_group.name + ': ' + tag.name
  end
  
  def self.last_six_days
    where('taggings.created_at > ?', Time.zone.now - 6.days)
  end
  
end
