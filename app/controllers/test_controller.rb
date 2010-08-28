class TestController < ApplicationController
  
# auto_complete_for :group_choice, :name
# auto_complete_for :curriculum_choice, :name
# auto_complete_for :curriculum_cost, :name
# auto_complete_for :special_requirement, :name

  before_filter :login_required
  require_role "admin"
  
  def index
       # render :file => 'app/views/volunteer_mailer/index.rhtml'
  end
  
  def deliver_confirm_lk
      involvement = Involvement.find(26)
      email = VolunteerMailer.create_confirm(involvement)
      redirect_to :controller => 'checkin', :action => 'home'
  end
  
  def confirm_team
    @team = Team.find(params[:team_id])
    @team.involvements.collect do |involvement|
      if involvement.has_email?
        VolunteerMailer.deliver_confirm(involvement)
      end
    end
    render :text => 'Render something. Give some feedback.'
  end
  
  def sendmail
     email = params[:email]
  	#  recipient = email[recipient]
  	 subject  = email[:subject]
  	 recipients = email[:recipient]
  	 message = email[:message]
  	  #message = email[message]
        VolunteerMailer.deliver_test_email(subject, recipients, message)
        #return if request.xhr?
        render :text => 'Message sent successfully'
  end
  
  def send_test
    subject = params[:email][:subject]
    VolunteerMailer.deliver_test_email
    render :text => 'Message was sent successfully.'
  end
  
  def find
    
    str = "0 and 99"
    #str.split
    start_age = str.split[0].to_i
    end_age = str.split[2].to_i
    start_range = (Time.now - start_age.years).strftime('%Y-%m-%d')
    end_range = (Time.now - end_age.years).strftime('%Y-%m-%d')
    cond = Caboose::EZ::Condition.new do
      birthdate < start_range
      birthdate > end_range
    end
    @cond = cond.to_sql
    @found_poeple = Person.find(:all)
  end
  
  def choices
    
  end
  
  def set_choices
    @special_requirement = SpecialRequirement.find_or_create_by_name(params[:special_requirement][:name])
    redirect_to (:back)
  end
  
  def list_people
    @people = Person.find(:all)
  end
  
  def new_contact
    if params[:household_id].nil?
      @person = Person.find(params[:person_id])
    else
      @household = Household.find(params[:household_id])
    end
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
        contact[:responsible_user_id] = @contact_type.default_responsible_user_id
        contact[:responsible_department_id] = @contact_type.default_responsible_department_id
        @contact = Contact.new(contact)
        @contact.save
        contact_count += 1
      end
    end
    flash[:notice] = "#{contact_count} contact(s) successsfully created."
    uri = session[:original_uri]
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
  
  def set_max_dates
    @people = Person.find(:all)
    @people.each do |p|
      p.set_recent_attend
    end
  end
  
  def set_min_dates
    @people = Person.find(:all)
    @people.each do |p|
        p.set_first_attend
    end
  end
  
  def set_attend_counts
    @people = Person.find(:all)
    @people.each do |p|
      p.set_attend_count
    end
  end
  
  def set_attendance_statuses
    @people = Person.find(:all)
    @people.each do |p|
       p.set_attendance_status
    end
  end
  
  def set_advance_decline
    @people = Person.find(:all)
    @people.each do |p|
        p.set_status_advance_decline
    end
  end
  
  def find_dead_enrollments
      @people_ids = Person.find(:all).collect {|p| p.id}
      @enrollment_ids = Enrollment.find(:all).collect {|e| e.person_id}
      @dead_enrollments = @enrollment_ids.reject {|e| @people_ids.include?(e)} #these are person_ids that refer to non-existant people
      @dead_enrollments.each do |d|
          @enrollments = Enrollment.find_all_by_person_id(d)
          @enrollments.each do |e|
              e.destroy
          end
      end       
  end
  
  def find_dead_involvements
        @people_ids = Person.find(:all).collect {|p| p.id}
        @involvement_ids = Involvement.find(:all).collect {|i| i.person_id}
        @dead_involvements = @involvement_ids.reject {|i| @people_ids.include?(i)} #these are person_ids that refer to non-existant people
        @dead_involvements.each do |d|
            @involvements = Involvement.find_all_by_person_id(d)
            @involvements.each do |i|
                i.destroy
            end
        end       
    end
    
    def find_dead_contributions
        @people_ids = Person.find(:all).collect {|p| p.id}
        @contribution_ids = Contribution.find(:all).collect {|e| e.person_id}
        @dead_contributions = @contribution_ids.reject {|e| @people_ids.include?(e)} #these are person_ids that refer to non-existant people
        @dead_contributions.each do |d|
            @contributions = Contribution.find_all_by_person_id(d)
            @contributions.each do |e|
                e.destroy
            end
        end       
    end
    
    def nested_fields
        @bucket = Bucket.new
    end
    
    def cool_table
        
    end
    
    def cool_table_alt
    end
    
    def set_household_statuses
        @households = Household.find(:all)
        @households.each do |h|
            h.set_attendance_status
        end
    end
    
    def tabs_test
        
    end
    
    def set_start_dates
        @involvements = Involvement.find(:all)
        @involvements.each do |i|
            i.update_attribute(:start_date, i.created_at.to_date)
        end
    end
    
    def set_worship_attends
        @people = Person.find(:all)
        @people.each do |p|
            p.set_worship_attends
        end
    end
    
    def set_max_worship_date
        @people = Person.find(:all)
        @people.each do |p|
            p.set_max_worship_date
        end
    end
    
    def set_attribution_stamp
        @contacts = Contact.find(:all)
        @contacts.each do |c|
            c.update_attribute(:stamp, c.attribution_stamp)
        end
    end
    
    def set_contacts_closed_at
        @contacts = Contact.find(:all)
        @contacts.each do |c|
            if c.openn == false
                c.update_attribute(:closed_at, c.updated_at)
            end
        end
    end
    
    def view_chart
      @graph = open_flash_chart_object(600,300, '/test/extra_tt', true, '/')     
    end
    
    def extra_tt
      data_1 = Line.new(2, '#9933CC')
      data_1.key('Page Views', 10)

      data_2 = LineHollow.new(2,5,'#CC3399')
      data_2.key("Downloads",10)

      data_3 = LineHollow.new(2,4,'#80a033')
      data_3.key("Bounces", 10)

      (0..12).each do |i|
        data_1.add_data_tip(rand(5) + 14, "(Extra: #{i})")
        data_2.add_data_tip(rand(5) + 8,  "(Extra: #{i})")
        data_3.add_data_tip(rand(6) + 1,  "(Extra: #{i})")
      end

      g = Graph.new
      g.title("Many Data lines and Extra tooltips", "{font-size: 20px; color: #736AFF}")
      g.data_sets << data_1
      g.data_sets << data_2
      g.data_sets << data_3

      g.set_tool_tip('#x_label# [#val#]<br>#tip#')
      g.set_x_labels(%w(Jan Feb Mar Apr May Jun Jul Aug Sept Oct Nov Dec))
      g.set_x_label_style(10, '#000000', 0, 2)

      g.set_y_max(20)
      g.set_y_label_steps(4)
      g.set_y_legend("Open Flash Chart", 12, "#736AFF")

      render :text => g.render
    end
    
    def do_address_stamps
        @households = Household.find(:all)
        @households.each do |h|
            h.update_attribute(:address,h.address_stamp)
        end
    end
    
    def do_geocodes
        @households = Household.find(:all)
        @households.each do |h|
            h.pub_geocode_address
        end
    end
    
    def lookup_geocodes
        # your list of places. In a real app, this would come from the database,
        # and have more robust descriptions
        places = [
          {:address=>'555 Irving, San Francisco, CA',:description=>'Irving'},
          {:address=>'1401 Valencia St, San Francisco, CA',:description=>'Valencia'},
          {:address=>'501 Cole St, San Francisco, CA',:description=>'Cole'},
          {:address=>'150 Church st, San Francisco, CA',:description=>'Church'} 
         ]

        # this loop will do the geo lookup for each place
        places.each_with_index do |place,index|
          # get the geocode by calling our own get_geocode(address) method
          geocode = get_geocode place[:address]

          # geo_code is now a hash with keys :latitude and :longitude
          # place these values back into our "database" (array of hashes)
          place[:latitude]=geocode[:latitude]
          place[:longitude]=geocode[:longitude]    

        end

        #place the result in the session so we can use it for display
        session[:places] = places

        #let the user know the lookup went ok
        render :text=> 'Looked up the geocodes for '+places.length.to_s+
    	' address and stored the result in the session . . .'

      end

      def show_google_map
        # all we're going to do is loop through the @places array on the page
        @places= Household.find(:all, :conditions => ['lat IS NOT NULL AND lng IS NOT NULL'])
      end
      
      def change_contacts
        bucket = Contact.find(:all)
        bucket.each do |c|
            case c.responsible_ministry_id
            when 2
                new_id = 4
            when 1
                new_id = 1
            when 3
                new_id = 6
            when 4
                new_id = 7
            when 6
                new_id = 15
            end
            c.update_attribute(:responsible_ministry_id, new_id)
        end
      end
      
      def set_roots_tree_id
        value = 1
        Group.roots.each do |root|
            root.update_attribute(:tree_id, value)
            value = value + 1
        end
      end
      
      def set_tree_ids
        Group.roots.each do |r|
          r.kids.each do |k|
            k.update_attribute(:tree_id,r.tree_id)
            k.kids.each do |kid|
              kid.update_attribute(:tree_id,r.tree_id)
              kid.kids.each do |g|
                g.update_attribute(:tree_id,r.tree_id)
              end
            end
          end
        end
      end
      
      def set_contr_count_and_date
        options =  {}
        EmailWorker.asynch_do_setup_person_contr_fields(options)
        redirect_to :controller => 'dashboard'
      end
      
      def setup_attendance_trackers
        options = {}
        EmailWorker.asynch_setup_attendance_trackers(options)
        redirect_to :controller => 'dashboard'
      end

      private
      def get_geocode(address)
        logger.debug 'starting geocoder call for address: '+address
        # this is where we call the geocoding web service
        server = XMLRPC::Client.new2('http://rpc.geocoder.us/service/xmlrpc')
        result = server.call2('geocode', address)
        logger.debug "Geocode call: "+result.inspect

        return {:success=> true, :latitude=> result[1][0]['lat'], 
    		:longitude=> result[1][0]['long']}
      end
  
end
