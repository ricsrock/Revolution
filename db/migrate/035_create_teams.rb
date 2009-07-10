class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.column :responsible_person_id, :integer
      t.column :responsible_person_title, :string
      t.column :purpose, :text
      t.column :win, :text
    end
  end

  def self.down
    drop_table :teams
  end
end
