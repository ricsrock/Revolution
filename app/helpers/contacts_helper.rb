module ContactsHelper
  
  def title(contact)
    contact.contact_type.name + " - " + contact.stamp + " (#{contact.status})"
  end
  
end
