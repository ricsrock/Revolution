class Ministry < ActiveRecord::Base
  belongs_to :department
  has_many :teams, :conditions => {:deleted_at => nil}
  has_many :jobs, :through => :teams
  has_many :involvements, :through => :jobs
  has_many :involved_people, :through => :involvements
  belongs_to :responsible_person, :class_name => "Person", :foreign_key => "responsible_person_id"
  belongs_to :department
  has_many :open_contacts, :class_name => "Contact", :foreign_key => "responsible_ministry_id", :conditions => ["(contacts.deleted_at IS NULL) AND ((contacts.closed_at IS NULL) OR ((contacts.reopen_at > contacts.closed_at) AND (contacts.reopen_at < '#{Time.now.to_s(:db)}')))"]
  
  
  acts_as_paranoid
  
  def self.find_by_department_id(department_id)
    find(:all, :conditions => ['department_id LIKE ?', department_id])
  end
  
    def average_open_contact_age
        ages = self.open_contacts.collect {|c| c.age_in_days.floor}
        ages.sum/ages.length
    end

    def in_progress_contacts
        self.open_contacts.reject {|c| c.follow_ups.empty?}
    end

    def in_progress_status
      if self.in_progress_contacts.length == 1
          "#{self.in_progress_contacts.length} of this ministries' open contacts is in progress."
      else
          "#{self.in_progress_contacts.length} of this ministries' open contacts are in progress."
      end
    end
    
    def open_in_progress_summary
        "#{self.open_contacts.length}/#{self.in_progress_contacts.length}"
    end
  
end
