module ContactsHelper
  
  def zoom_helper(user,f)
    if user.authorized_for_follow_up?(f)
      link_to (image_tag "zoom_16x16.gif", :size => "12x12", :border => 0, :title => "Show this follow-up"), :controller => 'follow_ups', :action => 'show', :id => f
    else
      "no access"
    end
  end
end
