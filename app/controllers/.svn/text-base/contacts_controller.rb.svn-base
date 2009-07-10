class ContactsController < ApplicationController
  
  before_filter :login_required
  
  require_role ["checkin_user", "supervisor"]
  require_role "admin", :only => :follow_up, :unless => "current_user.authorized_for_contact?(params[:id].to_i) or (current_user.authorized_for_ministry?(Contact.find(params[:id]).responsible_ministry.id.to_s) unless Contact.find(params[:id]).responsible_ministry.nil?)"
  require_role "admin", :only => [:executive, :destroy]
  
  def list
    @contacts = Contact.find(:all)
  end
  
  def executive
    @contacts = Contact.find(:all,
                             :order => ['contacts.created_at ASC'],
                             :conditions => ["(contacts.deleted_at IS NULL) AND ((contacts.closed_at IS NULL) OR ((contacts.reopen_at > contacts.closed_at) AND (contacts.reopen_at < '#{Time.now.to_s(:db)}')))"],
                             :limit => 50)
    session[:uri] = request.request_uri
  end
  
  def x_search_contacts_orig
    if params[:contact][:status] == "Open"
      open = "1"
    elsif params[:contact][:status] == "Closed"
      open = "0"
    else
      open = "%"
    end
    if params[:contact][:sort] == "Date Opened"
      order = 'created_at ASC'
    elsif params[:contact][:sort] == "Contact Type"
      order = 'contact_type_id ASC'
    else
      order = 'person_id, household_id ASC'
    end
    if params[:user][:login] == ""
      @contacts = Contact.find_by_open_order(open,order)
    else
      @user = User.find_by_login(params[:user][:login])
      user_id = @user.id.to_s
      @contacts = Contact.find_by_user_id_open_order(user_id,open,order)
    end
  end
  
  def new_contact
    if params[:household_id].nil?
      @person = Person.find(params[:person_id]) unless params[:person_id].nil?
    elsif
      @household = Household.find(params[:household_id]) : params[:household_id].nil?
    end
  end
  
  def new_mass
    @smart_group = SmartGroup.find(params[:id])
    @found_people = @smart_group.found_people
  end
  
  def search_contacts
    status_result = params[:contact][:status]
    if params[:user].nil?
      login_result = current_user.login
    else
      login_result = params[:user][:login]
    end
    order_result = params[:contact][:sort]
    range_result = params[:contact][:range]
    type_result = params[:contact][:type_id]
    @contacts = Contact.find_with_ez_where(status_result,login_result,order_result,range_result,type_result)
    session[:found_contacts] = @contacts.collect {|c| c.id}
  end
  
  def add_contacts
    contact_count = 0
    params[:created_by] = current_user.login
    params[:contact_type].each_value do |contact|
      if contact[:included] == "1"
        contact.delete("included")
        @contact_type = ContactType.find(contact[:contact_type_id])
        contact[:created_by] = params[:created_by]
        contact[:person_id] = params[:person_id]
        contact[:household_id] = params[:household_id]
        contact[:responsible_user_id] = contact[:responsible_user_id].blank? ? @contact_type.default_responsible_user_id : contact[:responsible_user_id]
        contact[:responsible_ministry_id] = @contact_type.default_responsible_ministry_id
        @contact = Contact.new(contact)
        @contact.save
        contact_count += 1
      end
    end
    flash[:notice] = "#{contact_count} contact(s) successsfully created."
    uri = session[:original_uri]
    uri ||= '/dashboard/index/'
    session[:original_uri] = nil
    redirect_to(uri)
  end
  
  def add_mass_contacts
    contact_count = 0
    params[:created_by] = current_user.login
    if params[:contact_type]
      params[:contact_type].each_value do |contact|
        if contact[:included] == "1"
          contact.delete("included")
          @contact_type = ContactType.find(contact[:contact_type_id])
          contact[:created_by] = params[:created_by]
          contact[:responsible_user_id] = contact[:responsible_user_id].blank? ? @contact_type.default_responsible_user_id : contact[:responsible_user_id]
          contact[:responsible_ministry_id] = @contact_type.default_responsible_ministry_id
          params[:included_people].each do |person_id|
            contact[:person_id] = person_id
            @contact = Contact.new(contact)
            @contact.save
            contact_count += 1
          end
        end
      end
    end
    flash[:notice] = "#{contact_count} contact(s) successsfully created."
    uri = session[:original_uri]
    uri ||= '/dashboard/index/'
    session[:original_uri] = nil
    redirect_to(uri)
  end
  
  def form_changed
    unless params[:id] == ""
      @form_id = params[:id]
      render :partial => 'form', :locals => {:form_id => @form_id}
    else
      render :text => 'Select a form silly goose!'
    end
  end
  
  
  def follow_up
    @contact = Contact.find(params[:id])
  end
  
  def manage
    @contacts = current_user.open_contacts
    session[:uri] = request.request_uri
    session[:found_contacts] = @contacts.collect {|c| c.id}
  end
  
  def create_follow_up
    @contact = Contact.find(params[:contact_id])
    follow_up = params[:follow_up]
    follow_up[:created_by] = current_user.login
    follow_up[:created_at] = Time.now
    follow_up[:contact_id] = @contact.id
    @follow_up = FollowUp.new(follow_up)
    if @follow_up.save
      if params[:close_contact] == "true"
        @contact.update_attributes(:openn => false,
                                  :updated_by => current_user.login,
                                  :closed_at => Time.now)
        flash[:notice] = "Follow-Up successfully added and the contact has been closed."
        if params[:reopen_contact] == "true"
            @contact.update_attribute(:reopen_at, (Time.now + params[:reopen][:days].to_i.days))
            flash[:notice] << " The contact will be re-opened in #{params[:reopen][:days]} days."
        else
            flash[:notice] << " The contact is not scheduled to be re-opened."
        end
      else
        flash[:notice] = "Follow-up successfully created and the contact has been left open."
      end
      if params[:transfer_contact] == "true"
        @contact.update_attributes(:responsible_user_id => params[:contact][:responsible_user_id],
                                   :updated_by => current_user.login)
        @contact.transfer(current_user.email)
        flash[:notice] << " Responsibility for the contact was successfully transferred. Email notification has been sent."
      end
       redirect_to_where?(current_user,@contact)
    else
      render :action => 'follow_up', :id => @contact
    end
    @contact.deliver_follow_up_notify_email
  end
  
  def show_add_form
    @contact = Contact.find(params[:contact])
  end
  
  def hide_form
    @contact = Contact.find(params[:contact])
  end
  
  def do_something
    if params[:selected_ids]
        session[:selected_ids] = params[:selected_ids]
        action_to_take = params[:contact][:choice]
        if action_to_take == "Multi-Close"
          render :partial => 'multi_close', :layout => true
        elsif action_to_take == "Export Mail Merge File"
          render :partial => 'export_contact_info', :layout => true
        end
    else
        render :text => "You must select at least one contact, silly goose!", :layout => true
    end
  end
  
  def close_multiple
    closed_count = 0
    session[:selected_ids].each do |id|
     @follow_up = FollowUp.new(:notes => params[:follow_up][:comments],
                                :follow_up_type_id => params[:follow_up_type][:id],
                                :created_by => current_user.login)
      @contact = Contact.find(id)
      @contact.follow_ups << @follow_up
      if @contact.contact_type.multiple_close == true
        @contact.update_attributes(:openn => false, :closed_at => Time.now)
        closed_count =+ 1
      else
        flash[:notice] = "Sorry. That contact type (#{@contact.contact_type.name}) doesn't allow multi-close. \n The follow-up notes were added,
                          but you'll have to close them each individually."
      end
    end
    flash[:notice] ||= "#{closed_count} contacts were succesfully closed... with your notes added."
    redirect_to :action => 'manage'
  end
  
  def summary
    @users = User.find(:all)
  end
  
  def transfer_box_clicked
    if params[:transfer_contact] ==  "true"
        @transfer = false
    else
        @transfer = true
    end
  end
  
  def close_box_clicked
    if params[:close_contact] == "true"
      @close = true
      @transfer = false
    else
      @close = false
    end
  end
  
  def follow_up_form_changed
    if params[:close_contact] == "true"
      @close_disabled = false
      @transfer_disabled = true
      @transfer_checked = false
      @re_open_box_disabled = false
      @days_select_disabled = true
      
    else
      @close_disabled = false
      @transfer_disabled = false
      @transfer_checked = false
      @re_open_box_disabled = true
      @re_open_checked = false
    end
    
    if params[:transfer_contact] == "true"
      @close_checked = false
      @close_disabled = true
      @transfer_checked = true unless params[:close_contact] =="true"
    end    
  end
  
  def show_follow_ups
    @contact = Contact.find(params[:id])
  end
  
  def hide_follow_ups
    @contact = Contact.find(params[:id])
  end
  
  def show_all_follow_ups
    @contacts = Contact.find(:all, :conditions => ['id IN (?)', session[:found_contacts]])
  end
  
  def hide_all_follow_ups
    @contacts = Contact.find(:all, :conditions => ['id IN (?)', session[:found_contacts]])
  end
  
  
end
