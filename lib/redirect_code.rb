module RedirectCode
  def redirect_to_where?(user,contact)
    if user.authorized_for_contact?(contact.id)
      redirect_to :action => 'follow_up', :id => contact
    else
      redirect_to :action => 'manage'
    end
  end
end