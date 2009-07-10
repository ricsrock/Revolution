class AddAutoInstanceTypes < ActiveRecord::Migration
  def self.up
    create_table :auto_instance_types do |t|
      t.column :event_type_id, :integer
      t.column :instance_type_id, :integer
    end
  end

  def self.down
    drop_table :auto_instance_types
  end
end
