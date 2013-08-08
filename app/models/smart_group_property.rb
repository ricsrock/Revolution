class SmartGroupProperty < ActiveRecord::Base
  has_many :property_operators
  has_many :operators, through: :property_operators
  has_many :smart_group_rules
  
  validates :short, :uniqueness => true
  validates :short, :prose, :presence => true
  
  def left
    people = Arel::Table.new(:people)
    groups = Arel::Table.new(:groups)
    tags = Arel::Table.new(:tags)
    trackers = Arel::Table.new(:attendance_trackers)
    households = Arel::Table.new(:households)
    case short
    when "age"
      people[:birthdate]
    when "created_date"
      people[:created_at]
    when "gender"
      people[:gender]
    when "first_attend"
      people[:min_date]
    when "enrolled"
      people[:enrolled]
    when "involved"
      people[:involved]
    when "have_group"
      groups[:name]
    when "not_have_tag"
      people[:id]
    when "have_tag"
      tags[:name]
    when "picture"
      people[:has_a_picture]
    when "total_attends"
      people[:attend_count]
    when "first_group_attend"
      trackers[:first_attend]
    when "group_count"
      trackers[:count]
    when "mapped"
      [households[:latitude], households[:longitude]]
    when "household_position"
      people[:household_position]
    when "attendance_status"
      people[:attendance_status]
    when "household_name"
      households[:name]
    when "birthday"
      birthdate = Arel::Attribute.new(Arel::Table.new(:people), :birthdate)
      Arel::Nodes::NamedFunction.new('MONTH', [birthdate])
    when "zip"
      households[:zip]
    when "recent_attend"
      people[:max_date]
    when "recent_group_attend"
      trackers[:first_attend]
    end
  end
  
end
