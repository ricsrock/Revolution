class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :person
  
  validates_uniqueness_of :tag_id, :scope => [:person_id, :start_date]
  validates_presence_of :tag_id
  
  SORT_BY = ["Person", "Date ASC", "Date Desc", "Tag"]
  
  def self.find_by_controller(name)
    find(:all, :conditions => ['tags.name LIKE ?', '%' + name + '%'],
               :select => ['taggings.id, tags.name, taggings.person_id'],
               :joins => ['JOIN tags ON tags.id = taggings.tag_id'])
  end
  
  def self.find_by_tag_name(tag_name)
    find(:all, :conditions => ['tags.name LIKE ?', '%' + tag_name + '%'],
               :select => ['taggings.id, tags.name, taggings.person_id'],
               :joins => ['JOIN tags ON tags.id = taggings.tag_id'])
  end
  
  def find_by_tag_group(tag_group)
    
      openn_cond = Caboose::EZ::Condition.new do
          openn == status_result
        end
        sql_conditions << openn_cond
    
  end
  
  def self.find_by_tag_group(tag_group_id,sort,range_name,tag_id)
    tag_ids = Tag.find_all_by_tag_group_id(tag_group_id).collect {|t| t.id}
    
    if sort == "Date ASC"
        order = 'taggings.start_date, tags.name, people.last_name, people.first_name ASC'
    elsif sort == "Person"
        order = 'people.last_name, people.first_name, tags.name, taggings.start_date ASC'
    elsif sort == "Date Desc"
        order = 'taggings.start_date DESC, tags.name ASC, people.last_name ASC, people.first_name ASC'
    elsif sort == "Tag"
        order = 'tags.name, taggings.start_date, people.last_name, people.first_name ASC'
    end
    
    sql_conditions = []
    
    case tag_id
    when ""
        cond = Caboose::EZ::Condition.new :tags do
            any do
                id === tag_ids
            end
        end
    else
        cond = Caboose::EZ::Condition.new :tags do
            any do
                id === tag_id
            end
        end
    end
    
    sql_conditions << cond
    
    unless range_name == "All"
      if range_name == "This Month"
        start_range = Time.now.beginning_of_month
        end_range = Time.now
      elsif range_name == "Last 7 Days"
          start_range = (Time.now - 7.days)
          end_range = Time.now
      elsif range_name == "This Week"
          start_range = Time.now.beginning_of_week
          end_range = Time.now
      elsif range_name == "Last 14 Days"
          start_range = (Time.now - 14.days)
          end_range = Time.now
      elsif range_name == "Last 30 Days"
        start_range = (Time.now - 30.days)
        end_range = Time.now
      end
      range_condition = Caboose::EZ::Condition.new :taggings do
        start_date <=> (start_range..end_range)
      end
      sql_conditions << range_condition
    end
    
    combined_cond = Caboose::EZ::Condition.new
    sql_conditions.each do |item|
      combined_cond << item
    end
    
    Tagging.find(:all, :conditions => combined_cond.to_sql,
                       :include => [:person, :tag],
                       :order => order)
  end
  
  
end
