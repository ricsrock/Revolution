class ChangeAgeOperators < ActiveRecord::Migration
  def change
    o = Operator.where(:prose => "older than").first
    o.update_attribute(:short, 'older')
    o = Operator.where(:prose => "younger than").first
    o.update_attribute(:short, 'younger')
  end
end
