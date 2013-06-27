class Search < ActiveRecord::Base
  
  serialize :parameters, Hash
  
  acts_as_stampable
  
  def results
    find_objects
  end
  
  
  private
  
  def find_objects
    q = self.klass.capitalize.constantize.all
    #loop through each parameter and build up the query...
    parameters.each do |k,v|
      q = q.self.klass.capitalize.constantize.send(k.to_sym,v)
    end
    
    #do something with sorting... which field, which direction...
    q
  end
  
  def contributor_name_like(v=nil)
    self.klass.capitalize.constantize.where('donations.name LIKE ?', v)
  end
end
