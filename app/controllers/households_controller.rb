class HouseholdsController < ApplicationController
  
  before_filter :login_required
  require_role ["checkin_user", "supervisor"]
  require_role "supervisor", :only => [:destroy, :delete_phone]
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    letter = params[:letter]
    letter ||= '%'
    conditions = "#{letter}%"
    if params[:letter]
      number_per_page = 100
    else
      number_per_page = 20
    end
#   @found_households = Household.find_by_first_letter(letter)
#   @household_pages, @households = paginate(:households, 
#                                           :order => :name,
#                                           :conditions => ['name LIKE ?', conditions],
#                                             :per_page => number_per_page)
    @households = Household.paginate :page => 1, :conditions => ['name like ?', conditions], :order => 'name', :per_page => number_per_page
  end

  def show
    @household = Household.find(params[:id], :include => [:phones, :emails, :people])
    session[:original_uri] = request.request_uri
    current_user.set_preference(:household_partial, "communication")
  end
  
  def change_partial
      @household = Household.find(params[:household_id])
      @new_partial = params[:new_partial]
      current_user.set_preference!(:household_partial, @new_partial)
      current_user.set_preference!(:household_tab, params[:new_partial])
      @variable = params[:new_partial]
    end

  def new
    @household = Household.new
    @household.people.build
    @household.phones.build
    @household.emails.build
    @groups = Group.find(:all)
  end
  
  def quick_add
      guest_number = Household.maximum('id').to_i + 1
      @household = Household.new
      @household.people.build
      @household.phones.build
      @groups = Group.find(:all)
  end
  
  def new_add_person
    @household = Household.new
    5.times { @household.people.build } 
  end
  
  def create_add_person
      @household = Household.new(params[:household])
      params[:people].each_value do |person|
        @household.people.build(person) unless person.values.all?(&:blank?)
      end
      if @household.save
        redirect_to :action => 'index'
      else
        render :action => 'new'
      end
   end
    


  def create
    params[:household][:created_at] = Time.now
    params[:household][:created_by] = current_user.login
    @household = Household.new(params[:household])
    params[:people].each_value { |person| @household.people.build(person)}
    @values = []
    unless params[:emails].nil? #don't do anything if there are no emails. To fix 'nil' error. (12/17/07)
      params[:emails].each_value do |email|
        @household.emails.build(email) unless email[:email].blank?
      end
    end
    unless params[:phones].nil? #don't do anything if there are no phones. added proactively. Can't hurt. Can it? (12/17/07)
      params[:phones].each_value { |phone| @household.phones.build(phone)}
    end
    if @household.save
      session[:query] = @household.name
      flash[:notice] = "Household successfully created."
      redirect_to :controller => 'checkin', :action => 'home'
    else
      flash[:notice] = "Household could not be created."
      render :action => 'new'
    end
  end
  
  
  def quick_create
      params[:household][:created_at] = Time.now
      params[:household][:created_by] = current_user.login
      @household = Household.new(params[:household])
      params[:people].each_value { |person| person[:household_position] = "Dependent"}
      params[:people].each_value { |person| @household.people.build(person)}
      @values = []
      unless params[:phones].nil? #don't do anything if there are no phones. added proactively. Can't hurt. Can it? (12/17/07)
        params[:phones].each_value { |phone| @household.phones.build(phone)}
      end
      if @household.save
        session[:query] = @household.name
        flash[:notice] = "Household successfully created.<br> Be sure to give this family an info form and get it back filled out completely!"
        redirect_to :controller => 'checkin', :action => 'home'        
      else
        flash[:notice] = "Household could not be created."
        render :action => 'quick_add'
      end
    end
  
  def add_people
    @household = Household.find(params[:household_id])
    params[:people].each_value do |person|
      @household.people.build(person).save
    end
    redirect_to :action => 'list'
  end

  def edit
    @household = Household.find(params[:id])
  end

  def update
    params[:household][:updated_at] = Time.now
    params[:household][:updated_by] = current_user.login
    @household = Household.find(params[:id])
    if @household.update_attributes(params[:household])
      @household.update_attribute(:address, @household.address_stamp)
      if @household.pub_geocode_address
          flash[:notice] = 'Household was successfully updated & geocoded'
      else
          flash[:notice] = 'Household was successfully but could not be geocoded'
      end
      redirect_to :action => 'show', :id => @household
    else
      render :action => 'edit'
    end
  end

  def destroy
    @household = Household.find(params[:id])
#  if ! @household.people.empty?
#      flash[:notice] = "You can't delete this household because it has people in it."
#  elsif ! @household.contacts.empty?
#      flash[:notice] = "You can't delete this household because it has contacts."
#  else
        flash[:notice] = []
        @household.destroy
        @household.errors.each_full do |e|
            flash[:notice] << e
        end
    redirect_to :action => 'list'
  end
  
  
  def add_person
    @person = Person.new
  end
  
  def add_person_quick
    @person = Person.new
  end
  
  def add_email
    @email = Email.new
  end
  
  def add_phone
    @phone = Phone.new
  end
  
  def add_a_person
    params[:person][:created_at] = Time.now
    params[:person][:created_by] = current_user.login
    @household = Household.find(params[:household_id])
    @person = Person.create(params[:person])
    @household.people << @person
    if @person.save
      flash[:notice] = "Person was successfully added to this household."
      redirect_to :action => 'show', :id => @household
    else
      flash[:notice] = "Person could not be added. Please check the information and try again."
      @view = "display:block;"
      render :action => 'show', :id => @household
    end
  end
  
  def add_an_email
    @household = Household.find(params[:household_id])
    @email = Email.create(params[:email])
    @household.emails << @email
    redirect_to :action => 'show', :id => @household
  end
  
  def add_a_phone
    @household = Household.find(params[:household_id])
    @phone = Phone.create(params[:phone])
    @household.phones << @phone
    redirect_to :action => 'show', :id => @household
  end
  
  def x_add_person
    @household = Household.find(params[:id])
    @person = Person.new(params[:person])
    @household.people << @person
    if @person.save
      flash[:notice] = 'Person was added to household'
    end
    redirect_to(:back)
  end
  
  def update_phones
    @household = Household.find(params[:id])
    @household.phones.each { |p| p.attributes = params[:phone][p.id.to_s] }
    @household.phones.each(&:save!)
    redirect_to :action => 'show', :id => @household
  end
  
  def update_emails
    @household = Household.find(params[:id])
    @household.emails.each { |p| p.attributes = params[:email][p.id.to_s] }
    @household.emails.each(&:save!)
    redirect_to :action => 'show', :id => @household
  end
  
  def delete_phone
    @household = Household.find(params[:household])
    Phone.find(params[:id]).destroy
    redirect_to :action => 'show', :id => @household
  end
  
  def delete_email
    @household = Household.find(params[:household])
    Email.find(params[:id]).destroy
    redirect_to :action => 'show', :id => @household
  end
  
  def code_address
    @household = Household.find(params[:id])
    @household.update_attribute(:address, @household.address_stamp)
    if @household.pub_geocode_address
        flash[:notice] = "Address successfully geocoded."
    else
        flash[:notice] = "Address could not be geocoded."
    end
    redirect_to :action => 'show', :id => @household
  end
  
  def map
    @places = Household.find_all_by_id(params[:id])
  end
  
  def near_by
      params[:within] ? @range = params[:within][:range] : @range = 5
      @household = Household.find(params[:id])
      # @first_weed = @smart_group.found_households.reject { |p| p.household.nil? }
      @places = Household.find(:all, :origin => @household.address_stamp, :within => @range, :order => 'distance asc')
    end
  
end
