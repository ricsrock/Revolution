class ChangeSmartGroupRules < ActiveRecord::Migration
  def self.up
    add_column :smart_group_rules, :property_id, :integer
    add_column :smart_group_rules, :operator_id, :integer
  end

  def self.down
    remove_column :smart_group_rules, :property_id
    remove_column :smart_group_rules, :operator_id
  end
end
