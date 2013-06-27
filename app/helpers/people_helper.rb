module PeopleHelper
  
  def full_name(person)
    person.first_name + ' ' + person.last_name
  end
  
  def name_with_id(object)
    if object.is_a?(Person)
      full_name(object) + ' (#' + object.id.to_s + ')'
    else
      object.name + ' (#' + object.id.to_s + ')'
    end
  end
  
  def family_name(person)
    if person.last_name == person.household.name
      person.first_name
    else
      person.first_name + ' ' + person.last_name
    end
  end
  
  def household_people(person)
    a = []
    person.household.people.sort_by(&:sort_order).each do |p|
      if p.id == person.id
        a << family_name(p)
      else
        a << link_to(family_name(p), person_path(p))
      end
    end
    raw a.to_sentence
  end
  
  def age(person)
    if person.birthdate.blank?
      result = "no dob"
    else
      dob = person.birthdate.to_date
      now = Time.now.utc.to_date
      result = now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
    end
    result.to_s
  end
  
  def best_phone(person)
    result = person.phones.where(:primary => true).first
    result ||= person.phones.first
    result ? pretty(result) : "no phone"
  end
  
  def best_email(person)
    result = person.emails.where(:primary => true).first
    result ||= person.emails.first
    result ? result.email : "no email"
  end
  
	def address_block(person)
	  block = '<span>'
	  unless person.address1.blank?
	    block << '<div>' + person.address1 + '</div>'
    end
    unless person.address2.blank?
      block << '<div>' + person.address2 + '</div>'
    end
    unless person.city.blank?
    block << '<div>' + person.city + ' '
    end
    unless person.state.blank?
      block << person.state + '  '
    end
    unless person.zip.blank?
      block << person.zip.to_s
    end
    block << '</div>'
	  block << '</span>'
	  block
	end
  
end
