class Phone < ActiveRecord::Base
  belongs_to :phonable, :polymorphic => true
  
  validates :number,:length => { :minimum => 10, :maximum => 10, },
                    :presence => true
  validates :phonable_type, :phonable_id, :presence => true
  validates_numericality_of :number, :only_integer => true, :message => "can only contain numbers"
end
