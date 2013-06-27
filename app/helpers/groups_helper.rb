module GroupsHelper
  def group_breadcrumb(id)
    @group = Group.find(id)
    @result = "<ul class='breadcrumbs'>"
    @group.self_and_ancestors.each do |g|
      @result << "<li>"
      @result << link_to(g.name, group_path(g))
      @result << "</li>"
      # @result << ' ' + ' > ' unless g.children.length < 1
    end
      if @group.children.length > 0
        @result << "<li data-no-turbolink>&nbsp;"
        @result << collection_select('group','id',@group.children.sort_by(&:name), 'id','name',
                                      {:include_blank => true, :prompt => "jump to", remote: true},
                                      {:class => "group-jumper", :style => "width:250px;", :data => "no-turbolink"})
        @result << "</li>"
    end
    @result << "</ul>"
    @result
  end
  
  def status_label(group)
    if group.status == 'Active'
      @result = "<span class='label radius success'>Active</span>"
    elsif group.status == 'Archived'
      @result = "<span class='label radius alert'>Archived</span>"
    else
      @result = "<span class='label radius'>Unknown</span>"
    end
    @result.html_safe
  end
  
  def group_icon(group)
    case group.type
    when "Branch"
      result = "<i class='icon-sitemap'></i>"
    when "SmallGroup"
      result = "<i class='icon-group'></i>"
    when "CheckinGroup"
      result = "<i class='icon-check'></i>"
    when "List"
      result = "<i class='icon-list'></i>"
    else
      result = "<i class='icon-info-sign'></i>"
    end
    result.html_safe
  end
  
end
