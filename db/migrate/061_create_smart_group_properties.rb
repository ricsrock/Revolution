class CreateSmartGroupProperties < ActiveRecord::Migration
  def self.up
    create_table :smart_group_properties do |t|
      t.column :prose, :string
      t.column :short, :string
    end
  end

  def self.down
    drop_table :smart_group_properties
  end
end
