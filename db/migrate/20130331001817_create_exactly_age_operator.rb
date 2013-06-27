class CreateExactlyAgeOperator < ActiveRecord::Migration
  def change
    o = Operator.new(prose: 'precisely', short: 'precisely')
    o.save
    # o = Operator.where(:prose => 'precisely').first
    p = SmartGroupProperty.where(:short => 'age').first
    exactly = Operator.where(:short => 'exactly').first
    p.operators.delete(exactly)
    p.operators << o
  end
end
