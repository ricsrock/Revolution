class SmartGroupRule < ActiveRecord::Base
  belongs_to :smart_group, :class_name => "SmartGroup", :foreign_key => "smart_group_id"
  belongs_to :smart_group_property, :class_name => "SmartGroupProperty", :foreign_key => "property_id", :inverse_of => :smart_group_rules
  belongs_to :operator, :class_name => "Operator", :foreign_key => "operator_id", :inverse_of => :smart_group_rules
  
  validates :property_id, :presence => true
  
  before_destroy :must_have_at_least_one_smart_group_rule
  
  attr_accessor :extra
  
  def must_have_at_least_one_smart_group_rule
    if self.smart_group.smart_group_rules.length <= 1
    # errors.add(:base, 'Must have at least one Smart Group Rule') if smart_group_rules.all?(&:marked_for_destruction?)
      errors.add(:base, 'Must have at least one Smart Group Rule') 
      false
    end
  end
  
  # I think I can delete this code...
  def operator_short
    operator.short || false
  end
  
  def right
    case smart_group_property.short
      
    when "age"
      if operator.short == "precisely"
        Arel::Nodes::And.new(
                            ((Time.now - (self.content.to_i + 1).years) + 1.day).to_date.to_s(:db),
                            (Time.now - self.content.to_i.years).to_date.to_s(:db)
                            )
      else
        (Time.now - self.content.to_i.years).to_date.to_s(:db)
      end
      
    when "created_date"
      (Time.now - self.content.to_i.weeks).to_s(:db)
      
    when "gender"
      self.content
      
    when "first_attend"
      if operator.short == "between"
        start_date = self.content.split[0].to_i
        end_date = self.content.split[2].to_i
        start_range = (Time.now - start_date.weeks).to_date.to_s(:db)
        end_range = (Time.now - end_date.weeks).to_date.to_s(:db)
        values = [start_range, end_range].sort
        values
      else
        (Time.now - self.content.to_i.weeks).to_date.to_s(:db)
      end
      
    when "enrolled"
      content == "true" ? true : false
      
    when "enrolled"
      content == "true" ? true : false
      
    when "have_group"
      content.split(',').flatten.each(&:strip!)
      
    when "not_have_tag"
      tag_list = content.split(',').flatten.each(&:strip!)
      p = Arel::Table.new(:people)
      t = Arel::Table.new(:tags)
      taggings = Arel::Table.new(:taggings)
      sub_q = p.join(taggings).on(taggings[:person_id].eq(p[:id])).where(t[:name].in(tag_list)).project(p[:id]).join(t).on(t[:id].eq(taggings[:tag_id]))
      sub_q
      
    when "have_tag"
      content.split(',').flatten.each(&:strip!)
      
    when "picture"
      content == "true" ? true : false
      
    when "total_attends"
      if operator.short == "between"
        values = []
        a = content.split
        values << a[0]
        values << a[2]
        values.sort
      else
        content.to_i
      end
      
    when "first_group_attend"
      array = content.split('!').flatten.each(&:strip!)
      (Time.now - array[0].to_i.weeks).to_date.to_s(:db)
      
    when "group_count"
      array = content.split('!').flatten.each(&:strip!)
      array[0].to_i
      
    when "mapped"
      content == "true" ? true : false
      
    when "household_position"
      content.split(',').flatten.each(&:strip!)
      
    when "attendance_status"
      content.split(',').flatten.each(&:strip!)
      
    when "birthday"
      months_from_now = self.content.to_i
      (Time.now.month + months_from_now)
      
    when "zip"
      content.split(',').flatten.each(&:strip!)
      
    when "recent_attend"
      if operator.short == "between"
        start_date = self.content.split[0].to_i
        end_date = self.content.split[2].to_i
        start_range = (Time.now - start_date.weeks).to_date.to_s(:db)
        end_range = (Time.now - end_date.weeks).to_date.to_s(:db)
        values = [start_range, end_range].sort
        values
      else
        (Time.now - self.content.to_i.weeks).to_date.to_s(:db)
      end
    
    when "recent_group_attend"
      array = content.split('!').flatten.each(&:strip!)
      (Time.now - array[0].to_i.weeks).to_date.to_s(:db)
     
    end
  end
  
  def left
    smart_group_property.left
  end
  
  def clause
    if self.operator && ( self.smart_group_property.short != "first_group_attend" ) && ( self.smart_group_property.short != "group_count" ) && ( self.smart_group_property.short != "recent_group_attend" )
      logger.info("smart_group_rule#clause called operator#node")
      operator.node(left, right)
    else
      logger.info("smart_group_rule#clause is false on the first if")
      if right.is_a?(Array)
        logger.info("smart_group_rule#clause says right is an array")
        Arel::Nodes::In.new(left, right)
      elsif smart_group_property.short == "not_have_tag"
        Arel::Nodes::NotIn.new(left,right)
      elsif smart_group_property.short == "exclusive_tags"
        result = []
        tag_list = content.split(',').flatten.each(&:strip!)
        tag_list.each_with_index do |tag, index|
          result << " INNER JOIN taggings taggings_#{index.to_s} ON taggings_#{index.to_s}.person_id = people.id INNER JOIN tags tags_#{index.to_s} ON (tags_#{index.to_s}.id = taggings_#{index.to_s}.tag_id AND tags_#{index.to_s}.name = '#{tag.to_s}') "
        end
        result = result.flatten.join(' ')
        Arel::Nodes::SqlLiteral.new(result)
      elsif smart_group_property.short == "first_group_attend" or smart_group_property.short == "recent_group_attend"
        trackers = Arel::Table.new(:attendance_trackers)
        array = content.split('!').flatten.each(&:strip!)
        Arel::Nodes::And.new([Arel::Nodes::Equality.new(trackers[:group_id], array[1]), operator.node(left,right)])
      elsif smart_group_property.short == "group_count"
        trackers = Arel::Table.new(:attendance_trackers)
        array = content.split('!').flatten.each(&:strip!)
        Arel::Nodes::And.new([Arel::Nodes::Equality.new(trackers[:group_id], array[1]), operator.node(left,right)])
      elsif smart_group_property.short == "mapped"
        if self.right
          Arel::Nodes::And.new([Arel::Nodes::NotEqual.new(left[0], nil), Arel::Nodes::NotEqual.new(left[1], nil)])
        else
          Arel::Nodes::And.new([Arel::Nodes::Equality.new(left[0], nil), Arel::Nodes::Equality.new(left[1], nil)])
        end
      else
        Arel::Nodes::Equality.new(left, right)
      end
    end
  end
  
end
