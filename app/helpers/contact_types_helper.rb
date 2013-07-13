module ContactTypesHelper
  def ct_status_label(contact_type)
    if contact_type.status == 'Active'
      @result = "<span class='label radius success'>Active</span>"
    elsif contact_type.status == 'In-Active'
      @result = "<span class='label radius alert'>In-Active</span>"
    else
      @result = "<span class='label radius'>Unknown</span>"
    end
    @result.html_safe
  end
end
