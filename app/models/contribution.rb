class Contribution < ActiveRecord::Base
  has_many :donations, dependent: :destroy
  
  # belongs_to :person, :class_name => "Person", :foreign_key => "person_id"
  belongs_to :batch, :class_name => "Batch", :foreign_key => "batch_id"
  belongs_to :contributable, :polymorphic => true
  
  validates :date, :batch_id, :contributable_id, :contributable_type, :presence => true
  
  validate :must_have_at_least_one_donation
  
  accepts_nested_attributes_for :donations, :reject_if => proc { |attributes| attributes.any? {|k,v| v.blank?} }, allow_destroy: true
  
  acts_as_stampable
  
  
  def must_have_at_least_one_donation
    errors.add(:base, 'Must have at least one donation') if donations.all?(&:marked_for_destruction?)
  end
  
  def attributes_for_deposit_sheet
    attributes = []
    attributes << self.check_num
    attributes << self.contributable.full_name
    attributes << self.total
  end
  
end
