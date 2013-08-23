class AddBysToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :created_by, :string
    add_column :settings, :updated_by, :string
  end
end
