class CreateInterjections < ActiveRecord::Migration
  def change
    create_table :interjections, :force => true do |t|
      t.string :name
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end  
end