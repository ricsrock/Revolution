class Operator < ActiveRecord::Base
  
  has_many :property_operators
  has_many :smart_group_properties, through: :property_operators
  has_many :smart_group_rules, :inverse_of => :operator
  
  validates :prose, :uniqueness => true
  validates :prose, :short, :presence => true
  
  def node(left, right)
    case short
    when "after", "greater", "younger"
      Arel::Nodes::GreaterThan.new(left, right)
    when "before", "less", "older"
      Arel::Nodes::LessThan.new(left, right)
    when "between"
      # right must be an array!
      Arel::Nodes::Between.new(left, Arel::Nodes::And.new(right[0], right[1]))
    when "exactly"
      Arel::Nodes::Equality.new(left, right)
    when "matches"
      Arel::Nodes::Matches.new(left, '%' + right + '%')
    when "precisely"
      Arel::Nodes::Between.new(left, right)
    end
  end
  
end
