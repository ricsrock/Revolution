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
  
  def household_list(household)
    a = []
    household.people.sort_by(&:sort_order).each do |p|
      a << link_to(family_name(p), person_path(p))
    end
    raw a.to_sentence
  end
  
  def names_with_ages(household)
    household.people.sort_by {|p| p.sort_order}.collect {|s| s.family_name + ' (' + s.age.to_s + ')'}.to_sentence
  end
  
  def household_name_with_id(household)
    "#{household.name} (#{household.id.to_s})"
  end
  
  def household_info_for_search_results(household)
    "<div><strong>#{household.name} (#{household.id.to_s})</strong></div>" +
    "<div>" + names_with_ages(household) + "</div>" +
    "<div>" +  household.address1 + ' ' + household.city + ', ' + household.state + "</div><br>"
  end
  
end
