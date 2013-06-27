class IndexMaxDateOnPeople < ActiveRecord::Migration
  def change
    add_index :people, :max_date
  end
end