class CreateTools < ActiveRecord::Migration
  def self.up
    create_table :tools do |t|
    end
  end

  def self.down
    drop_table :tools
  end
end
