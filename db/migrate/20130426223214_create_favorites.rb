class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :favoritable, polymorphic: true
      t.belongs_to :user
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
    add_index :favorites, :favoritable_id
    add_index :favorites, :favoritable_type
    add_index :favorites, :user_id
  end
end