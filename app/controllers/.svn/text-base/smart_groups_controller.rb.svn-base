class SmartGroupsController < ApplicationController
  
    before_filter :login_required
  
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @smart_group_pages, @smart_groups = paginate :smart_groups, :per_page => 10
  end

  def show
    @smart_group = SmartGroup.find(params[:id])
  end

  def new
    @smart_group = SmartGroup.new
    @smart_group.smart_group_rules.build
  end

  def create
    params[:smart_group][:created_by] = current_user.login
    @smart_group = SmartGroup.new(params[:smart_group])
    if params[:rule]
      params[:rule].each_value do |rule|
        rule[:content] = rule[:content] + ", (group id " + rule[:extra] + ")" if rule[:extra]
        @smart_group.smart_group_rules.build(rule)
      end
    else
      flash[:notice] = "You must create at least one rule."
    end
    #@smart_group.valid?
    #@smart_group.check_for_at_least_one_rule
    if @smart_group.save
      flash[:notice] = 'SmartGroup was successfully created.'
      redirect_to :controller => 'groups', :action => 'tree_view'
    else
      render :action => 'new'
    end
  end

  def edit
    @smart_group = SmartGroup.find(params[:id])
  end

  def update
    params[:smart_group][:updated_by] = current_user.login
    @smart_group = SmartGroup.find(params[:id])
    if @smart_group.update_attributes(params[:smart_group])
      flash[:notice] = 'SmartGroup was successfully updated.'
      redirect_to :action => 'show', :id => @smart_group
    else
      render :action => 'edit'
    end
  end

  def destroy
    SmartGroup.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def property_changed
    @property = SmartGroupProperty.find(params[:id])
  end
  
  def property_changed_show
    @property = SmartGroupProperty.find(params[:id])
  end
  
  def add_rule
    @rule = SmartGroupRule.new
  end
  
  def add_rule_show
    unless params[:rule][0][:operator_id].nil?
      params[:rule][0][:content] = params[:rule][0][:content] + ", (group id " + params[:rule][0][:extra] + ")" if params[:rule][0][:extra]
      @new_rule = SmartGroupRule.new(:property_id => params[:property][:id],
                                     :operator_id => params[:rule][0][:operator_id],
                                     :content => params[:rule][0][:content])
      else
      @new_rule = SmartGroupRule.new(:property_id => params[:property][:id],
                                     :content => params[:rule][0][:content])
      end
      @smart_group = SmartGroup.find(params[:smart_group_id])
      @smart_group.smart_group_rules << @new_rule
      flash[:notice] = "Rule was successfully added to this smart group."
      @smart_group.smart_group_rules.reload
  end
  

    
  def delete_rule
      @smart_group = SmartGroup.find(params[:smart_group_id])
      if SmartGroupRule.find(params[:rule_id]).destroy
        flash[:notice] = "Rule was deleted."
      else
        flash[:notice] = "You must have at least one rule."
      end
      redirect_to :action => 'show', :id => @smart_group
  end
  
  def print_phone_list
    @smart_group = SmartGroup.find(params[:id])
  end
  
  def map
    @smart_group = SmartGroup.find(params[:id])
    @first_weed = @smart_group.found_households.reject { |p| p.household.nil? }
    @places = @first_weed.reject { |p| p.household.lat.nil? or p.household.lng.nil? }.sort_by {|r| r.household.name}
  end
      

end
