class IframeController < ApplicationController
  
  uses_tiny_mce
  
  def index
    @meets_on = session[:meets_on]
    @meets_on ||= '%'
    @category_ids = session[:category_ids]
    @category_ids ||= WebCategory.find(:all).collect(&:id)
    @groups = Group.web_groups(@meets_on,@category_ids)
    @web_categories = WebCategory.find(:all)
  end
  
  def filter_list
    if params[:select][:week_day] == 'Any'
      session[:meets_on] = '%'
    else
      session[:meets_on] = params[:select][:week_day]
    end
    session[:category_ids] = params[:select][:category_ids]
    redirect_to :action => 'index'
  end
  
  def set_groups_to_no
    Group.update_all(:show_on_web => false)
  end
  
  def show_group
    @group = Group.find(params[:id])
  end
  
  def contact_group_leader
    @group = Group.find(params[:group_id])
  end
  
  def express_interest
    @group = Group.find(params[:group_id])
    person_name = params[:person][:name]
    person_email = params[:person][:email]
    person_message = params[:person][:message]
    @leader = Person.find(@group.small_group_leader.id) if @group.small_group_leader
    to_email = @leader.best_email_smart
    group = @group
    
    if @leader
        unless @leader.best_email.nil?
            VolunteerMailer.deliver_express_interest_small_group(person_name, person_email, person_message, group, to_email)
        end
    end
    
    @contact_type = ContactType.find_by_name("I'm interested in small groups")
    contact = Hash.new
    contact[:contact_type_id] = @contact_type.id
    contact[:created_by] = 'system'
    contact[:person_id] = params[:person_id]
    contact[:household_id] = params[:household_id]
    contact[:responsible_user_id] = @contact_type.default_responsible_user_id
    contact[:responsible_ministry_id] = @contact_type.default_responsible_ministry_id
    contact[:comments] = 'Group Name: ' << @group.name << ' :: ' << 'Person Name: ' << person_name << ' :: ' << 'Person Email: ' << person_email << ' :: ' <<
                         'Message: ' << person_message
    @contact = Contact.new(contact)
    @contact.save
        unless @contact.responsible_user_id.nil?
            current_user_email = 'info@rivervalleychurch.net'
            user = User.find(@contact.responsible_user_id)
            contact = Contact.find(@contact.id)
            VolunteerMailer.deliver_contact_notify(user, current_user_email, contact)
        end
    
    flash[:notice] = 'Your message has been sent. Thanks for expressing your interest in RVC small groups. We will contact you soon.'
    redirect_to(:action => 'index')
  end
  
  def contact_us
    if params[:contact_type_id]
      if ContactForm.find_by_name("Web Contacts").contact_types.collect {|c| c.id}.include?(params[:contact_type_id].to_i)
        @selected = params[:contact_type_id].to_i
      end
    else
      @selected = nil
    end

# @selected = "I'm interested in small groups"
# 
#  params[:languages] = "French"
#  pLanguages =  params[:languages]
#  @message = Struct.new(:contact_type, :first_name).new("19", "Bob")
   @m = Struct.new("Message",:contact_type, :first_name, :last_name, :sender_email, :text, :send_copy)
   @message = @m.new(@selected, 'First Name','Last Name','Your Email', 'message text', '0') unless @message
  end
  
  def send_contact
    @errors = []
    @errors << "You must select a message type. <br>" if params[:message][:contact_type] == ""
    @errors << "You must provide your first name. <br>" if params[:message][:first_name].blank? or params[:message][:first_name] == "First Name"
    @errors << "You must provide your last name. <br>" if params[:message][:last_name].blank? or params[:message][:last_name] == "Last Name"
    @errors << "You must provide your email address. <br>" if params[:message][:sender_email].blank? or params[:message][:sender_email] == "Your Email"
    @errors << "You didn't type a message. <br>" if params[:message][:text].blank?
    @m = Struct.new("Message",:contact_type, :first_name, :last_name, :sender_email, :text, :send_copy)
    @message = @m.new(params[:message][:contact_type].to_i,
                      params[:message][:first_name],
                      params[:message][:last_name],
                      params[:message][:sender_email],
                      params[:message][:text],
                      params[:message][:send_copy])
    if @errors.empty?
      @contact_type = ContactType.find(params[:message][:contact_type])
      @contact = Contact.new(:created_by => 'system',
                             :contact_type_id => params[:message][:contact_type],
                             :responsible_user_id => @contact_type.default_responsible_user.id,
                             :comments => "This contact was created through the RVC website. The person's name is #{params[:message][:first_name] rescue nil} #{params[:message][:last_name] rescue nil}.\n
                             Here is the message: #{params[:message][:text].gsub(/<\/?[^>]*>/,  "") rescue nil}")
    else
      @contact = Contact.new
    end
    if params[:message][:send_copy] == "1"
      @copy = "A copy of your message has been sent to the address you provided."
      VolunteerMailer.deliver_contact_us_copy(params[:message][:sender_email],
                                              params[:message][:text].gsub(/<\/?[^>]*>/,  ""),
                                              params[:message][:contact_type],
                                              params[:message][:first_name], 
                                              params[:message][:last_name])
    else
      @copy = "You have chosen not to receive a copy of the message."
    end
    if @contact.save && @errors.empty?
      flash[:notice] = "Your message has been sent. #{@copy}"
      redirect_to :action => 'contact_us'
    else
      flash[:notice] = "There problems sending your message: <br> #{@errors.each {|e| e }}"
      render :action => 'contact_us'
    end
    
    
  end
end
