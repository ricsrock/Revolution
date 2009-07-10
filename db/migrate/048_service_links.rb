class ServiceLinks < ActiveRecord::Migration
  def self.up
    create_table :service_links do |t|
      t.column :group_id, :integer
      t.column :team_id, :integer
    end
  end

  def self.down
    drop_table :service_links
  end
end
