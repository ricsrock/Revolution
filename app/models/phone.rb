class Phone < ActiveRecord::Base
  belongs_to :phonable, :polymorphic => true
  belongs_to :comm_type, :class_name => "CommType", :foreign_key => "comm_type_id"
  
  validates :number,:length => { :minimum => 10, :maximum => 10, },
                    :presence => true
  #validates :phonable_type, :phonable_id, :presence => true
  validates_numericality_of :number, :only_integer => true, :message => "can only contain numbers"
  
  def self.mobile
    where('comm_types.name = ?', 'Mobile').includes(:comm_type).references(:comm_types)
  end
    
  def s_formatted
    '(' + area_code + ') ' + exchange + '-' + station
  end

  def area_code
    number.length == 10 ? number[0..2] : ''
  end

  def exchange
    number.length == 10 ? number[3..5] : number[0..2]
  end

  def station
    number.length == 10 ? number[6..9] : number[3..6]
  end
  
end
