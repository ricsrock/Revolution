class FixDefaultCreatedAts < ActiveRecord::Migration
  def change
    # change_column :emails, :created_at, :datetime, null: true, default: nil
    change_column :emails, :updated_at, :datetime, null: true, default: nil
    
    change_column :involvements, :created_at, :datetime, null: true, default: nil
    change_column :involvements, :updated_at, :datetime, null: true, default: nil
    
    change_column :jobs, :created_at, :datetime, null: true, default: nil
    change_column :jobs, :updated_at, :datetime, null: true, default: nil
    
    change_column :ministries, :created_at, :datetime, null: true, default: nil
    change_column :ministries, :updated_at, :datetime, null: true, default: nil
    
    change_column :phones, :created_at, :datetime, null: true, default: nil
    change_column :phones, :updated_at, :datetime, null: true, default: nil
    
    change_column :tag_groups, :created_at, :datetime, null: true, default: nil
    change_column :tag_groups, :updated_at, :datetime, null: true, default: nil

    change_column :taggings, :created_at, :datetime, null: true, default: nil
    change_column :taggings, :updated_at, :datetime, null: true, default: nil

    change_column :tags, :created_at, :datetime, null: true, default: nil
    change_column :tags, :updated_at, :datetime, null: true, default: nil
    
    change_column :teams, :created_at, :datetime, null: true, default: nil
    change_column :teams, :updated_at, :datetime, null: true, default: nil
  end                 
end