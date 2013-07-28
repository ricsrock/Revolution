class SignUp < ActiveRecord::Base
  STEPS = ["first_name", "last_name", "gender", "phone"]
  
  attr_writer :current_step
  
  validates_presence_of :first_name, if: lambda { |s| s.current_step == "first_name" }
  validates_presence_of :last_name, if: lambda { |s| s.current_step == "last_name" }
  validates_presence_of :gender, if: lambda { |s| s.current_step == "gender" }
  validates :phone, :length => { :minimum => 10, :maximum => 10, }, if: lambda { |s| s.phone.present? }
  validates_numericality_of :phone, :only_integer => true, :message => "can only contain numbers", if: lambda { |s| s.phone.present? }
  
  
  # after_initialize :set_step
  
  def current_step
    @current_step || steps.first
  end

  def steps
    %w[first_name last_name gender phone]
  end

  def next_step
    self.current_step = steps[steps.index(current_step)+1]
    logger.info "-------- next step was called --------"
  end

  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end

  def first_step?
    current_step == steps.first
  end

  def last_step?
    current_step == steps.last
  end

  def all_valid?
    steps.all? do |step|
      self.current_step = step
      valid?
    end
  end
  
  
  # def set_step
  #   self.step ||= "first_name" if self.new_record?
  # end
  # 
  # def set_step_to(step)
  #   self.update_attribute(:step, step || SignUp::STEPS.first)
  # end
  # 
  # def current_step
  #   step || SignUp::STEPS.first
  # end
  # 
  # def next_step
  #   self.update_attribute(:step,SignUp::STEPS[SignUp::STEPS.index(self.step)+1])
  # end
  # 
  # def previous_step
  #   self.update_attribute(:step, SignUp::STEPS[SignUp::STEPS.index(self.step)-1])
  # end
  # 
  # def first_step?
  #   current_step == SignUp::STEPS.first
  # end
  # 
  # def last_step?
  #   current_step == SignUp::STEPS.last
  # end
  # 
  # def all_valid?
  #   SignUp::STEPS.all? do |step|
  #     self.set_step_to(step)
  #     self.valid?
  #   end
  # end
  
end
