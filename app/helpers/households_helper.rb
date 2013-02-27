module HouseholdsHelper
  
  def household_best_phone(household)
    result = household.phones.where(:primary => true).first
    result ||= household.phones.first
    result ? pretty(result) : "no phone"
  end
  
  def household_best_email(household)
    result = household.emails.where(:primary => true).first
    result ||= household.emails.first
    result ? result.email : "no email"
  end
end
