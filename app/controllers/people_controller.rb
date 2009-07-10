class PeopleController < ApplicationController
  
  before_filter :login_required
  
  require_role ["checkin_user", "supervisor"]
  require_role "admin", :only => [:destroy, :destroy_tagging]
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @person_pages, @people = paginate :people, :per_page => 10
  end

  def show
    @person = Person.find(params[:id])
    session[:person_partial] ||= "communication"
    session[:person_tab] ||= "communication"
    session[:sticky_person] = @person
    session[:original_uri] = request.request_uri
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(params[:person])
    if @person.save
      flash[:notice] = 'Person was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    params[:person][:updated_at] = Time.now
    params[:person][:updated_by] = current_user.login
    @person = Person.find(params[:id])
    if @person.update_attributes(params[:person])
      flash[:notice] = 'Person was successfully updated.'
      redirect_to :action => 'show', :id => @person
    else
      render :action => 'edit'
    end
  end

  def destroy
    @person = Person.find(params[:id])
    if @person.destroy
        redirect_to :action => 'list'
    else
        render :partial => 'errors', :layout => true
    end
  end
  
  def add_email
    @person = Person.find(params[:person_id])
    @email = Email.new(params[:email])
    @person.emails << @email
    redirect_to(:back)
  end
  
  def add_an_email
    @person = Person.find(params[:person_id])
    @email = Email.create(params[:email])
    @person.emails << @email
    @blah = []
    @email.errors.each_full {|e| @blah << e}
    flash[:notice] = @blah
    redirect_to :action => 'show', :id => @person
  end
  
  def add_a_phone
    @person = Person.find(params[:person_id])
    @phone = Phone.create(params[:phone])
    @person.phones << @phone
    @blah = []
    @phone.errors.each_full {|e| @blah << e}
    flash[:notice] = @blah
    redirect_to :action => 'show', :id => @person
  end
  
  def update_phones
    @person = Person.find(params[:id])
    @person.phones.each { |p| p.attributes = params[:phone][p.id.to_s] }
    @person.phones.each(&:save)
    redirect_to :action => 'show', :id => @person
  end
  
  def update_emails
    @person = Person.find(params[:id])
    @person.emails.each { |p| p.attributes = params[:email][p.id.to_s] }
    @person.emails.each(&:save)
    redirect_to :action => 'show', :id => @person
  end
  
  def delete_email
    @person = Person.find(params[:person])
    Email.find(params[:id]).destroy
    redirect_to :action => 'show', :id => @person
  end
  
  def delete_phone
    @person = Person.find(params[:person])
    Phone.find(params[:id]).destroy
    redirect_to :action => 'show', :id => @person
  end
  
  
  def tag_group_changed
    @tag_group = TagGroup.find(params[:id])
  end
  
  def change_partial
    @person = Person.find(params[:person_id])
    @new_partial = params[:new_partial]
    session[:person_partial] = @new_partial
    session[:person_tab] = params[:new_partial]
    @variable = params[:new_partial]
  end
  
  def destroy_tagging
    Tagging.find(params[:id]).destroy
  end
  
  def merge_duplicates
    @person = Person.find(params[:id])
  end
  
  def search_for_duplicates
    names = params[:person_name].split(',')
    original_id = params[:orginal_id]
	if names.length == 1
		 conditions = ["(first_name LIKE ? OR last_name LIKE ?) AND (people.id != ?)", params[:person_name].strip + '%', names[0].strip + '%',original_id]
	elsif names.length >= 2
		 conditions = ["first_name LIKE ? OR last_name LIKE ? AND (first_name LIKE ? OR last_name LIKE ?) AND (people.id != ?)",params[:person_name].strip + '%', names[0].strip + '%', names[1].strip + '%', names[1].strip + '%',original_id]
	end
	@found_people = Person.find(:all, :conditions => conditions, :limit => 10, :order => 'last_name ASC, first_name ASC')
  end
  
  def search_for_new_household
      name = params[:household_name]
      original_household_id = params[:current_household_id] || "%"
  	  conditions = ["(name LIKE ?) AND (households.id != ?)", params[:household_name].strip + '%',original_household_id]
  	  @found_households = Household.find(:all, :conditions => conditions, :limit => 10, :order => 'name ASC, address1 ASC')
  end
  
  def choose_dup
    @duplicate = Person.find(params[:id])
  end
  
  def choose_new
    @new = Household.find(params[:id])
  end
  
  def commit_merge
    @keeper = Person.find(params[:keeper_id])
    @duplicate = Person.find(params[:duplicate_id])
    #@old_household = Household.find(@duplicate.household)
    @new_household = Household.find(@keeper.household.id)
    #handle household

    #handle individual info...
    if @keeper.birthdate.nil?
        if @duplicate.birthdate
            @keeper.update_attribute(:birthdate,@duplicate.birthdate)
        end
    elsif params[:dup_keep_b_day]
        @keeper.update_attribute(:birthdate,@duplicate.birthdate)
    end
    
    if @keeper.default_group_id.nil?
        if @duplicate.default_group_id
            @keeper.update_attribute(:default_group_id,@duplicate.default_group_id)
        end
    elsif params[:dup_keep_checkin_group]
        @keeper.update_attribute(:default_group_id,@duplicate.default_group_id)
    end
    
    if @keeper.gender.nil?
        if @duplicate.gender
            @keeper.update_attribute(:gender,@duplicate.gender)
        end
    elsif params[:dup_keep_gender]
        @keeper.update_attribute(:gender,@duplicate.gender)
    end
    
    if @keeper.household_position.nil?
        if @duplicate.household_position
            @keeper.update_attribute(:household_position,@duplicate.household_position)
        end
    elsif params[:dup_keep_position]
        @keeper.update_attribute(:household_position,@duplicate.household_position)
    end
    
    #handle phones...
    phones_to_keep = []
    phones_to_keep << params[:dup_phones_to_keep]
    phones_to_keep << params[:phones]
    @keeper.do_keep_phones(phones_to_keep)
    
    #handle emails...
    emails_to_keep = []
    emails_to_keep << params[:dup_emails_to_keep]
    emails_to_keep << params[:emails]
    @keeper.do_keep_emails(emails_to_keep)
    
    #handle enrollments...
    @keeper.merge_enrollments(@duplicate.id)
    
    #handle involvements...
    @keeper.merge_involvements(@duplicate.id)
    
    #handle attendances...
    @keeper.merge_attendances(@duplicate.id)
    
    #handle taggings...
    @keeper.merge_taggings(@duplicate.id)
    
    #handle contacts...
    @keeper.merge_contacts(@duplicate.id)
    
    #handle contributions...
    @keeper.merge_contributions(@duplicate.id)
    
    @duplicate.destroy
    flash[:notice] = "Records have been merged and the duplicate has been deleted. (Not really. It's still there, just marked 'deleted')."
  end
  
  def commit_move
    @mover = Person.find(params[:mover_id])
    @new_household_id = params[:new_household_id]
    @mover.update_attribute(:household_id, @new_household_id)
    flash[:notice] = "#{@mover.full_name} has been moved to the new household."
  end
  
  def fact_sheet
    @person = Person.find(params[:id])
  end
  
  def new_picture
    @person = Person.find(params[:id])
  end
  
  def create_picture
      @person = Person.find(params[:person_id])
      params[:person][:updated_by] = current_user.login
      @person.update_attributes(params[:person])
      if @person.save_picture
          flash[:notice] = 'Picture was successfully created.'
          redirect_to :action => 'show', :id => @person
      else
          render :action => "new_picture", :id => @person
      end
  end
  
  def move_person
    @person = Person.find(params[:id])
  end
  
  def filter_attendances
    @person = Person.find(params[:person])
    chosen_group = params[:filter][:group_id]
    chosen_range = params[:filter][:range]
  end
  
  def new_relationship
    @person = Person.find(params[:id])
  end
  
  def delete_relationship
    @relationship = Relationship.find(params[:id])
    @relationship.destroy
    @person = Person.find(params[:person])
  end
  
  def relationship_type_changed
    @relationship_type = RelationshipType.find(params[:relationship_type_id])
    @person = Person.find(params[:id])
  end
  
  def live_search
    names = params[:search_term].split(',')
    if names.length == 1
			 conditions = ['first_name LIKE ? OR last_name LIKE ?', params[:search_term].strip + '%', names[0].strip + '%']
		elsif names.length >= 2
			 conditions = ['first_name LIKE ? OR last_name LIKE ? AND (first_name LIKE ? OR last_name LIKE ?)',params[:search_term].strip + '%', names[0].strip + '%', names[1].strip + '%', names[1].strip + '%']
		end
		@results = Person.find(:all, :conditions => conditions, :limit => 10, :order => 'last_name ASC, first_name ASC')		
  end
  
  def person_chosen
    @relates_to_person = Person.find(params[:id])
  end
  
  def relationship_details
    @relationship = Relationship.find(params[:id])
    @person = Person.find(params[:person_id])
  end
  
  def edit_relationship
    @relationship = Relationship.find(params[:id])
    @person = Person.find(params[:person])
  end
  
  def update_relationship
    params[:relationship][:updated_by] = current_user.login
    @relationship = Relationship.find(params[:id])
    params[:relationship][:deactivated_on] = Time.now if params[:relationship][:active] == "1"
    params[:relationship][:deactivated_on] = nil unless params[:relationship][:active]
    params[:relationship].delete(:active)
    @person = Person.find(params[:person])
    if @relationship.update_attributes(params[:relationship])
      redirect_to :action => 'show', :id => @person
    else
      render :action => 'show', :id => @person
    end
  end
  
  def relationships_tree
    @person = Person.find(params[:id])
    session[:tree_tag] = "tree"
  end
  
  def contacts
    @person = Person.find(params[:id])
  end
  
  def new_note
    @person = Person.find(params[:id])
  end
  
  def create_note
    @person = Person.find(params[:person_id])
    @note = Note.create(:type_id => params[:note][:type],
                 :created_by => current_user.login,
                 :confidential => params[:note][:confidential],
                 :text => params[:note][:text])
    @person.notes << @note
  end
  
  def cancel_new_note
    @person = Person.find(params[:person_id])
  end
  
  def view_note
    @person = Person.find(params[:person_id])
    @note = @person.notes.find(params[:id])
  end
  
end
