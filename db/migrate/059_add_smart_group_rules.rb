class AddSmartGroupRules < ActiveRecord::Migration
  def self.up
    create_table :smart_group_rules do |t|
      t.column :smart_group_id, :integer
      t.column :property, :string
      t.column :operator, :string
      t.column :value, :string
    end
  end

  def self.down
    drop_table :smart_group_rules
  end
end
