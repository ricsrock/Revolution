class CreateOperators < ActiveRecord::Migration
  def self.up
    create_table :operators do |t|
      t.column :smart_group_property_id, :integer
      t.column :prose, :string
      t.column :short, :string
    end
  end

  def self.down
    drop_table :operators
  end
end
