class CreateCheckinBackgrounds < ActiveRecord::Migration
  def change
    create_table :checkin_backgrounds do |t|
      t.string :name
      t.string :graphic

      t.timestamps
    end
  end
end
