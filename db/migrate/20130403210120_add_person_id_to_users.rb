class AddPersonIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :person_id, :integer
    add_index :users, :person_id
  end
end