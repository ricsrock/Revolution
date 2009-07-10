class Deployments < ActiveRecord::Migration
  def self.up
    create_table :deployments do |t|
      t.column :rotation_id, :integer
      t.column :involvement_id, :integer
    end
  end

  def self.down
    drop_table :deployments
  end
end
