class Contribution < ActiveRecord::Base
  belongs_to :contributable, :polymorphic => true#, :conditions => ['contributions.deleted_at IS NULL OR deleted_at > ?', Time.now]
  has_many :donations
  belongs_to :batch
  
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
    if self.contributable_type == 'person'
      self.person.last_name + ", " + self.person.first_name + " (#" + self.person.id.to_s + ")"
    else
      self.organization.name + " (#" + self.organization.id.to_s + ")"
    end
  end
end
