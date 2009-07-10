class SmartGroupRulesController < ApplicationController
  
    before_filter :login_required
  
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @smart_group_rule_pages, @smart_group_rules = paginate :smart_group_rules, :per_page => 10
  end

  def show
    @smart_group_rule = SmartGroupRule.find(params[:id])
  end

  def new
    @smart_group_rule = SmartGroupRule.new
  end

  def create
    @smart_group_rule = SmartGroupRule.new(params[:smart_group_rule])
    if @smart_group_rule.save
      flash[:notice] = 'SmartGroupRule was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @smart_group_rule = SmartGroupRule.find(params[:id])
  end

  def update
    @smart_group_rule = SmartGroupRule.find(params[:id])
    if @smart_group_rule.update_attributes(params[:smart_group_rule])
      flash[:notice] = 'SmartGroupRule was successfully updated.'
      redirect_to :action => 'show', :id => @smart_group_rule
    else
      render :action => 'edit'
    end
  end

  def destroy
    SmartGroupRule.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
