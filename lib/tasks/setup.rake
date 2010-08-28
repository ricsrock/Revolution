namespace :setup do

  desc "Do stuff needed to get rolling." 
  task(:initial_data => :environment) do
      #initial user - this guy gets admin role...
      @user = User.new(:first_name => "Joe", :last_name => "Admin", :login => "jadmin", :email => "joe@admin.com",
                       :password => "joeadmin", :password_confirmation => "joeadmin", :preferences => Hash.new)
      @user.save
      
      @household = Household.new(:name => "Testing", :address1 => "Test Street", :city => "City", :state => "ST", :zip => "71111")
      @household.save
      
      @group = Group.new(:name => "Initial", :tree_id => "1").save
      
      @person = Person.new(:first_name => "Tom", :last_name => "Testing", :default_group_id => @group.id, :household_position => "Primary Contact", :gender => "Male")
      @person.save
      
      @household.people << @person
      
      #get tags going...
      @tag_group = TagGroup.create(:name => "Leadership Qualifications", :created_by => "system")
      @tag_group.save
      @tags = ["Department Level", "Ministry Level", "Team Level", "Group Level", "Job Level"]
      @tags.each do |t|
        @tag = Tag.new(:created_by => "system", :name => t)
        @tag.save
        
        @tag_group.tags << @tag
      end
      
      @status_tag_group = TagGroup.create(:name => "Status Advance/Decline", :created_by => "system")
      @status_tag_group.save
      @tags = ["Guest Advance", "Guest Decline", "Inactive Advance", "Active Decline"]
      @tags.each do |t|
        @tag = Tag.new(:created_by => "system", :name => t)
        @tag.save
        
        @status_tag_group.tags << @tag
      end
      
      #settings initial...
      Setting.create(:current_instance => "1")
      
      #roles...
      @roles = [{:name => "admin", :alias => "Administrator", :description => "Has all privileges"},
                {:name => "supervisor", :alias => "Supervisor", :description => "Has most privileges"},
                {:name => "checkin_user", :alias => "Checkin User", :description => "Has privileges needed to serve as a checkin operator."},
                {:name => "financials", :alias => "Financials", :description => "Has access to financial records and reports."},
                {:name => "feeds", :alias => "Feeds", :description => "Has access to contact follow-up feeds."}]
      @roles.each do |r|
        @role = Role.new(r)
        @role.save
      end
      
      @admin_role = Role.find_by_name("admin")
      
      @user = User.find(:first)
      @user.roles << @admin_role
      
      #do smart group properties with operators...
      
      @sgp = SmartGroupProperty.create(:prose => "whose age is",:short => "age",:instructions => "enter a number")
        @operators = [{:prose => "older than", :short => "greater"},
                      {:prose => "between", :short => "between"},
                      {:prose => "younger than", :short => "less"}]
        @operators.each do |o|
          @operator = Operator.create(o)
          @sgp.operators << @operator
        end
      @sgp = SmartGroupProperty.create(:prose => "whose most recent attend is", :short => "recent_attend")
        @operators = [{:prose => "before this many weeks ago", :short => "before"},
                      {:prose => "after this many weeks ago", :short => "after"},
                      {:prose => "between the following range of weeks", :short => "between"}]
        @operators.each do |o|
          @operator = Operator.create(o)
          @sgp.operators << @operator
        end
      @sgp = SmartGroupProperty.create(:prose => "whose total number of attends is",:short => "total_attends")
        @operators = [{:prose => "between", :short => "between"},
                      {:prose => "exactly", :short => "exactly"},
                      {:prose => "less than", :short => "less"},
                      {:prose => "greater than", :short => "greater"}]
        @operators.each do |o|
          @operator = Operator.create(o)
          @sgp.operators << @operator
        end
      @sgp = SmartGroupProperty.create(:prose => "who are tagged with",:short => "have_tag",:instructions => "comma-separated tag names work like 'or'")
      @sgp = SmartGroupProperty.create(:prose => "whose gender is", :short => "gender")
      @sgp = SmartGroupProperty.create(:prose => "whose household position is", :short => "household_position")
      @sgp = SmartGroupProperty.create(:prose => "whose first attend was", :short => "first_attend")
        @operators = [{:prose => "before this many weeks ago", :short => "less_than"},
                      {:prose => "after this many weeks ago", :short => "more_than"},
                      {:prose => "between this range of weeks ago", :short => "between"}]
        @operators.each do |o|
          @operator = Operator.create(o)
          @sgp.operators << @operator
        end
      @sgp = SmartGroupProperty.create(:prose => "birthday is this many months from now:", :short => "birthday", :instructions => "0 for this month, 1 for next month, etc...")
      @sgp = SmartGroupProperty.create(:prose => "who are enrolled in", :short => "have_group", :instructions => "comma-separated group names work like 'or'")
      @sgp = SmartGroupProperty.create(:prose => "whose attendance status is", :short => "attendance_status")
      @sgp = SmartGroupProperty.create(:prose => "whose household zip code is", :short => "zip", :instructions => "comma-separated values work like 'or'")
      @sgp = SmartGroupProperty.create(:prose => "whose record was created", :short => "created_date")
        @operators = [{:prose => "before this many weeks ago", :short => "before"},
                      {:prose => "after this many weeks ago", :short => "after"},
                      {:prose => "within this range of weeks:", :short => "between"}]
        @operators.each do |o|
          @operator = Operator.create(o)
          @sgp.operators << @operator
        end  
      @sgp = SmartGroupProperty.create(:prose => "whose most recent contribution is", :short => "recent_contr", :instructions => "These are the instructions")
        @operators = [{:prose => "before this many weeks ago", :short => "before"},
                      {:prose => "after this many weeks ago", :short => "after"},
                      {:prose => "within this range of weeks:", :short => "between"}]
        @operators.each do |o|
          @operator = Operator.create(o)
          @sgp.operators << @operator
        end
      @sgp = SmartGroupProperty.create(:prose => "whose total number of contributions is", :short => "contr_count", :instructions => "These are the instructions")
        @operators = [{:prose => "between", :short => "between"},
                      {:prose => "exactly", :short => "exactly"},
                      {:prose => "less than", :short => "less"},
                      {:prose => "greater than", :short => "greater"}]
        @operators.each do |o|
          @operator = Operator.create(o)
          @sgp.operators << @operator
        end
        
      # adding group-specific smart group properties
      @sgp = SmartGroupProperty.create(:prose => "whose most recent group attend for", :short => "recent_group_attend", :instructions => "Choose a group, an operator, then select a number of weeks or a range (ex. 2 and 6).")
        @operators = [{:prose => "before this many weeks ago", :short => "before"},
                      {:prose => "after this many weeks ago", :short => "after"},
                      {:prose => "within this range of weeks:", :short => "between"}]
        @operators.each do |o|
          @operator = Operator.create(o)
          @sgp.operators << @operator
        end
        @sgp = SmartGroupProperty.create(:prose => "whose first group attend for", :short => "first_group_attend", :instructions => "Choose a group, an operator, then select a number of weeks or a range (ex. 2 and 6).")
          @operators = [{:prose => "before this many weeks ago", :short => "before"},
                        {:prose => "after this many weeks ago", :short => "after"},
                        {:prose => "within this range of weeks:", :short => "between"}]
          @operators.each do |o|
            @operator = Operator.create(o)
            @sgp.operators << @operator
          end
        @sgp = SmartGroupProperty.create(:prose => "whose total group attends for", :short => "group_count", :instructions => "Choose a group, an operator, then select a number of attends or a range (ex. 2 and 6).")
          @operators = [{:prose => "greater than", :short => "greater"},
                        {:prose => "less than", :short => "less"},
                        {:prose => "exactly", :short => "exactly"},
                        {:prose => "between", :short => "between"}]
          @operators.each do |o|
            @operator = Operator.create(o)
            @sgp.operators << @operator
          end
          @sgp = SmartGroupProperty.create(:prose => "who are tagged with (AND)", :short => "exclusive_tags", :instructions => "Comma-separated tag names work like 'and'")
          @sgp = SmartGroupProperty.create(:prose => "who are NOT tagged with", :short => "not_have_tag", :instructions => "Enter only one tag name")

      
      
      #do colors, adjectives, and animals...
      @colors = ["orange", "yellow", "magenta", "blue", "pink"]
      @colors.each do |c|
        MyColor.create(:name => c, :created_by => "system")
      end
      
      @animals = ["puppy","kitty", "giraffe", "anteater", "monkey"]
      @animals.each do |a|
        Animal.create(:name => a, :created_by => "system")
      end
      
      @adjectives = ["silly", "cute", "funny", "dizzy", "whacky", "laughing", "jumping", "dancing"]
      @adjectives.each do |adj|
        Adjective.create(:name => adj, :created_by => "system")
      end
      
      #do checkin types...
      CheckinType.create(:name => "Participant")
      CheckinType.create(:name => "Staff")
      
      #do comm types...
      @comm_types = ["Home", "Work", "Mobile"]
      @comm_types.each do |c|
        CommType.create(:name => c)
      end
      
      #do sms_setups...
      
      # This should be different for the newer version of the starling-starling gem ./script/workling_client stop/start
      #system "./script/workling_starling_client stop"
      #system "./script/workling_starling_client start"
      
      
  end

end