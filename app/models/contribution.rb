class Contribution < ActiveRecord::Base
  belongs_to :contributable, :polymorphic => true#, :conditions => ['contributions.deleted_at IS NULL OR deleted_at > ?', Time.now]
  has_many :donations
  belongs_to :batch
  
  accepts_nested_attributes_for :donations,:reject_if => lambda { |a| a.values.all?(&:blank?) }, :allow_destroy => true
  
  acts_as_paranoid
  
  validates_presence_of :contributable_id, :date, :batch_id
  
  after_create { |record|
      record.contributable.set_recent_contr
      record.contributable.set_contr_count
  }
  
  def calc_total
    self.donations.sum(:amount)
  end
  
  def do_total
    self.update_attribute(:total, self.donations.sum(:amount))
  end
  
  def year_week
    self.date.strftime('%Y') + '-' + self.date.strftime('%W')
  end
  
  def self.grand_total
    Contribution.sum('total')
  end
  
  def self.average(array_of_amounts)
    array_of_amounts.sum/array_of_amounts.size
  end
  
  def last_first_name
    if self.contributable_type == 'Person'
      self.contributable.last_name + ", " + self.contributable.first_name + " (#" + self.contributable.id.to_s + ")"
    else
      self.contributable.name + " (#" + self.contributable.id.to_s + ")"
    end
  end
  
  def unique_id
    self.contributable_type + self.contributable_id.to_s
  end
  
end
