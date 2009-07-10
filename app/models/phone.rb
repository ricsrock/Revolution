class Phone < ActiveRecord::Base
  belongs_to :phonable, :polymorphic => true
  belongs_to :comm_type, :class_name => "CommType", :foreign_key => "comm_type_id"
  belongs_to :sms_setup, :class_name => "SmsSetup", :foreign_key => "sms_setup_id"
  
  validates_length_of :number, :in => 7..10, :message => "is either too short or too long."
  validates_numericality_of :number, :message => "must contain only numbers."
  
  def before_validation
    self.number = number.gsub(/[^[:alnum:],]/,'') if attribute_present?("number")
    #gsub(/[^[:alnum:],]/,'')
  end
  
  def s_formatted
    '(' + area_code + ') ' + exchange + '-' + station
  end

    def area_code
      if number.length == 10
        number[0..2]
      else
        ''
      end
    end

    def exchange
      if number.length == 10
        number[3..5]
      else
        number[0..2]
      end
    end

    def station
      if number.length == 10
        number[6..9]
      else
        number[3..6]
      end
    end
    
    def sms_address
        if self.sms_setup
            "#{number}" + "#{self.sms_setup.config}"
        else
            false
        end
    end
  
end
