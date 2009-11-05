class ContributionsController < ApplicationController
  
    before_filter :login_required

    require_role [:financials]
  
  def index
    
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @contribution_pages, @contributions = paginate :contributions, :per_page => 10
  end

  def show
    @contribution = Contribution.find(params[:id])
  end

  def new
    @contribution = Contribution.new
  end
  
  def add_donation
    @donation = Donation.new
  end

  def create
    params[:contribution][:created_by] = current_user.login
    params[:contribution][:batch_id] = params[:batch_id]
    @contribution = Contribution.new(params[:contribution])
    params[:donations].each_value { |donation| @contribution.donations.build(donation)}
    if @contribution.save
      flash[:notice] = 'Contribution was successfully created.'
    else
      render :update do |page|
          page.replace_html("notice", :partial => 'errors')
          page.insert_html(:bottom, :notice, :partial => 'donation_errors')
      end
    end
    @batch = Batch.find(params[:batch_id])
    @contribution = Contribution.new
    @contribution.donations.build
  end
  

  def edit
    @contribution = Contribution.find(params[:id])
  end

  def update
    @contribution = Contribution.find(params[:id])
    if @contribution.update_attributes(params[:contribution])
      flash[:notice] = 'Contribution was successfully updated.'
      redirect_to :action => 'show', :id => @contribution
    else
      render :action => 'edit'
    end
  end

  def destroy
    Contribution.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def new_batch
    @batch = Batch.new
  end
  
  def create_batch
    params[:batch][:created_by] = current_user.login
    @batch = Batch.new(params[:batch])
    if @batch.save
      flash[:notice] = 'Batch was successfully created.'
      redirect_to :action => 'index'
    else
      render :action => 'new_batch'
    end
  end
  
  def enter
    @batch = Batch.find(params[:batch_id])
    if ! @batch.locked?
        @contribution = Contribution.new
        @contribution.donations.build
        @found_people = Person.find(:first)
        @found_organizations = Organization.find(:first)
    else
        flash[:notice] = "This batch is locked. It cannot be edited."
        redirect_to :action => 'index'
    end
  end
  
  def new_contribution
    @contribution = Contribution.new
    @contribution.donations.build
    @found_people = Person.find(:first)
    @found_organizations = Organization.find(:first)
  end
  
  def show_picker
    @found_people = Person.find(:all, :limit => 5, :order => ['last_name, first_name ASC'])
    @found_organizations = Organization.find(:all, :limit => 5, :order => ['name ASC'])
  end
  
  def search
    names = params[:search][:text].split(',')
		if names.length == 1
			 personConditions = ['first_name LIKE ? OR last_name LIKE ?', params[:search][:text].strip + '%', names[0].strip + '%']
		elsif names.length >= 2
			 personConditions = ['first_name LIKE ? OR last_name LIKE ? AND (first_name LIKE ? OR last_name LIKE ?)',params[:search][:text].strip + '%', names[0].strip + '%', names[1].strip + '%', names[1].strip + '%']
		end
    organizationConditions = ['name LIKE ?',params[:search][:text].strip + '%']
		@found_people = Person.find(:all, :conditions => personConditions, :limit => 10, :order => 'last_name ASC, first_name ASC')    
    @found_organizations = Organization.find(:all, :conditions => organizationConditions, :limit => 10, :order => 'name ASC')
  end
  
  def choose_person
    @person = Person.find(params[:id])
  end

  def choose_organization
    @organization = Organization.find(params[:id])
  end
  
  def set_totals
    @all_contr = Contribution.find(:all)
    @all_contr.each do |c|
      c.do_total
    end
  end
  
  def delete_contribution
    Contribution.find(params[:id]).destroy
    @batch = Batch.find(params[:batch_id])
  end
  
  def lock_and_done
    @batch = Batch.find(params[:batch_id])
    if @batch.update_attribute(:locked, true)
        flash[:notice] = "Batch locked."
    else
        flash[:notice] = "Batch could not be locked."
    end
    redirect_to :action => 'index'
  end
  
  def lock_batch
    @batch = Batch.find(params[:batch_id])
    @batch.update_attribute(:locked, true)
  end
  
  def unlock_batch
    @batch = Batch.find(params[:batch_id])
    @batch.update_attribute(:locked, false)
  end
  
  def edit_batch
    @batch = Batch.find(params[:id])
    if ! @batch.locked?
        true
    else
        flash[:notice] = "This batch is locked. It cannot be edited."
        redirect_to :action => 'index'
    end
  end
  
  def update_batch
    params[:batch][:updated_by] = current_user.login
    @batch = Batch.find(params[:id])
    if @batch.update_attributes(params[:batch])
        flash[:notice] = 'Batch was successfully updated.'
          redirect_to :action => 'index'
        else
          render :action => 'edit_batch'
        end
  end
  
  def deposit
    @batch = Batch.find(params[:id])
  end
  
  def inspector
      range_name = "Last 30 Days"
      fund_name = "All Funds"
      names = ''
      order = "Date ASC"
    @found_donations = Donation.find_by_filter(range_name,fund_name,names,order)
  end
  
  def filter_inspector
    range_name = params[:the][:range]
    fund_name = params[:the][:fund]
    names = params[:person_name].split(',')
    order = params[:the][:order]
    @found_donations = Donation.find_by_filter(range_name,fund_name,names,order)
  end
  
  def breakout
    @batch = Batch.find(params[:id])
  end
  
  def stats
      @c = Donation.find_by_fund_id("")
      @grouped = @c.group_by {|c| c.date.strftime('%Y-%m') unless c.date == false } 
  end
  
  def filter_stats
    date_range = Tool.range_condition_hash(params[:filter][:range])
    @c = Donation.find_by_fund_id_and_date_range(params[:filter][:fund_id],date_range)
    @grouped = @c.group_by {|c| c.date.strftime('%Y-%m') unless c.date == false }
  end
  
  def chart
      session[:flavor] = ""
      @fund_id = ""
  end
  
  def chart_pic
    @c = Donation.find_by_fund_id(params[:fund_id] || "")
    @grouped = @c.group_by {|c| c.date.strftime('%Y-%m') rescue nil }
    params[:fund_id] == "" or params[:fund_id].nil? ? @fund_name = "All Funds" : @fund_name = Fund.find(params[:fund_id]).name
     g = Gruff::Line.new(800)
     g.title = "Monthly Totals: #{@fund_name}"
     g.x_axis_label = "Month"
     g.y_axis_label = "Dollars"
     g.theme_37signals
     g.font = File.expand_path('artwork/fonts/Vera.ttf', RAILS_ROOT)
     months = []
     built_array = []
     avg_array = []
     @grouped.keys.each {|k| months << k}
     g.labels = Hash[*months.collect {|v| [months.index(v),v]}.flatten]
     # Modify this to represent your actual data models
     @grouped.each do |d,b|
       # Build data into array with something like
       built_array << b.collect {|c| c.amount.to_f}.sum
#   @w = b.group_by {|c| c.date.strftime('%Y-%W')}
#   t = []
#   @w.each do |w,g|
#       t << g.collect {|c| c.amount}.sum
#   end
#   avg_array << Contribution.average(t)
#
#   
     end
     #g.data('Weekly Average', avg_array)
     g.data('Monthly Total', built_array)
     send_data(g.to_blob, 
               :disposition => 'inline', 
               :type => 'image/png', 
               :filename => "chart.png")
  end
  
  def view_stats_chart
    @graph = open_flash_chart_object(500,250, '/contributions/stats_chart', true, '/')
  end
  
  def stats_chart
    @c = Donation.find_by_fund_id("")
    @grouped = @c.group_by {|c| c.date.strftime('%Y-%m') unless c.date == false }
    x_labels = []
    data_set = []
    @grouped.each do |g,v|
        x_labels << g
        data_set << v.collect {|c| c.amount.to_f}.sum
    end
    
    g = Graph.new
    g.title("Stats", '{font-size: 26px;}')
    g.set_data(data_set)
    g.set_x_labels(x_labels)
    g.set_y_max(20000)
    g.set_y_label_steps(2000)
    g.set_y_legend("Dollars",10, "#736AFF")
    render :text => g.render
    
  end
  
  def statements
    #pick a date range...
    @name_disabled = true
  end
  
  def enable_search_name
    if params[:search_name] == "1"
      @name_disabled = false
    else
      @name_disabled = true
    end
  end
  
  def run_statements
    person_condition = ""
    unless params[:range][:search_name].blank?
      if params[:range][:search_name].split(',').length > 1
        names = params[:range][:search_name].split(',')
        person_condition = "AND (people.last_name LIKE '#{names[0].strip + "%"}' AND people.first_name LIKE '#{names[1].strip + "%"}')"
      else
        person_condition = "AND ((people.last_name LIKE '#{params[:range][:search_name].strip + "%"}') OR (organizations.name LIKE '#{params[:range][:search_name].strip + "%"}'))"
      end
    end
    start_date = params[:range][:start_date].to_time
    end_date = params[:range][:end_date].to_time
    @donations = Donation.find(:all,
                              :joins => ["LEFT OUTER JOIN funds ON funds.id = donations.fund_id
                                          LEFT OUTER JOIN contributions ON contributions.id = donations.contribution_id
                                          LEFT OUTER JOIN people ON people.id = contributions.contributable_id AND contributions.contributable_type = 'Person'
                                          LEFT OUTER JOIN organizations ON organizations.id = contributions.contributable_id AND contributions.contributable_type = 'Organization'"],
                              :conditions => ["(contributions.date BETWEEN ? AND ?) AND (contributions.deleted_at IS NULL) #{person_condition}", start_date,end_date])
    
    @start_date = start_date
    @end_date = end_date
  end
  
  def run_statements_alt
    @donations = Donation.find(:all,
                              :include => [:contribution => [:person]])
    @donations = @donations.reject {|don| don.contribution.nil?}
    
  end
  
end
