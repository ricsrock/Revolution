module GroupsHelper
  
  def group_breadcrumb(id)
    @group = Group.find(id)
    @result = '<div>'
    @group.self_and_ancestors.each do |g|
      @result << link_to(g.name, :action => 'show', :id => g.id)
      @result << ' ' + '>' unless g.children.length < 1
    end
      if @group.children.length > 0
        @result << '[ '
        @group.children.each do |c|
          @result << link_to(c.name, :action => 'show', :id => c.id) + ' '
          end
        @result << ']'
    end
    @result << '</div>'
    @result
  end
  
  def group_breadcrumb_alt(id)
    @group = Group.find(id)
    @result = '<div>'
    @group.self_and_ancestors.each do |g|
      @result << link_to(g.name, :action => 'show', :id => g.id)
      @result << ' ' + '>' unless g.children.length < 1
    end
      if @group.children.length > 0
        @result << '[ '
        @result << collection_select('group','id',@group.children, 'id','name', {:include_blank => true, :prompt => "jump to"},{})
        @result << ']'
    end
    @result << '</div>'
    @result
  end
  
end
