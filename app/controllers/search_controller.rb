class SearchController < ApplicationController
  
  before_filter :login_required
  
  layout true
  
  def index
  end

  def auto_complete
		names = params[:search_criteria].split(',')
		
		if names.length == 1
			 conditions = ['first_name LIKE ? OR last_name LIKE ? AND (household_position <> ?)', params[:search_criteria].strip + '%', names[0].strip + '%', 'Deceased']
		elsif names.length >= 2
			 conditions = ['first_name LIKE ? OR last_name LIKE ? AND (first_name LIKE ? OR last_name LIKE ?) AND (household_position <> ?)',params[:search_criteria].strip + '%', names[0].strip + '%', names[1].strip + '%', names[1].strip + '%','Deceased']
		end
		@results = Person.find(:all, :conditions => conditions, :limit => 10, :order => 'last_name ASC, first_name ASC')
		for number in Phone.find(:all, :conditions => ['number LIKE ?', '%' + params[:search_criteria] + '%'], :limit => 10)
		  @results << number.phonable if number.phonable
		end
		for email in Email.find(:all, :conditions => ['email LIKE ?', '%' + params[:search_criteria] + '%'], :limit => 10)
		  @results << email.emailable if email.emailable
		end
		for group in Group.find(:all, :conditions => ['name LIKE ?', '%' + params[:search_criteria] + '%'], :order => 'name ASC', :limit => 10)
		  @results << group
	    end
	    for team in Team.find(:all, :conditions => ['name LIKE ?', '%' + params[:search_criteria] + '%'], :order => 'name ASC', :limit => 10)
		  @results << team
	    end
    for household in Household.find(:all, :conditions => ['name LIKE ? OR address1 LIKE ?', params[:search_criteria].strip + '%', '%' + params[:search_criteria].strip + '%'])
      @results << household
    end
    for org in Organization.find(:all, :conditions => ['name LIKE ? OR address1 LIKE ?', params[:search_criteria].strip + '%', '%' + params[:search_criteria].strip + '%'])
      @results << org
    end
    
		begin
  		@results.sort_by { |item| item.search_order  rescue nil}
  		@results.sort! { |item1, item2| item1.search_order rescue nil <=> item2.search_order rescue nil}
	  rescue
	  end
	  render :layout => false
#	render :update do |page|
#    page.replace_html "search-results-area", :partial => 'live_search_results', :locals => {:results => @results}
#   # page.layout => false
#  end
    
  end
end
