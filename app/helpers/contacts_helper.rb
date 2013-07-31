module ContactsHelper
  
  def title(contact)
    contact.contact_type.name + " - " + contact.stamp + " (#{contact.status})"
  end
  
  def first_name(contact)
    case contact.contactable.class.name
    when 'Person'
      contact.contactable.first_name
    when 'Household'
      ''
    else
      ''
    end
  end
  
  def last_name(contact)
    case contact.contactable.class.name
    when 'Person'
      contact.contactable.last_name
    when 'Household'
      contact.contactble.name
    else
      ''
    end
  end
  
  def contact_names_with_ages(contact)
    if contact.contactable.is_a?(Household)
      contact.contactable.people.sort_by {|p| p.sort_order}.collect {|s| s.family_name + ' (' + s.age.to_s + ')'}.to_sentence
    elsif contact.contactable.is_a?(Person)
      contact.contactable.household.people.sort_by {|p| p.sort_order}.collect {|s| s.family_name + ' (' + s.age.to_s + ')'}.to_sentence
    else
      ''
    end 
  end
  
  def attribution(contact)
    if contact.contactable
      link_to(contact.stamp, contact.contactable)
    else
      contact.stamp
    end
  end
  
  def info(contact)
    if contact.contactable.is_a?(Person)
      "#{contact.contactable.default_group.name rescue nil}"
    elsif contact.contactable.is_a?(Household)
      "Household Contact"
    end
  end  
  
end
