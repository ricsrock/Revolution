class CreateRecipients < ActiveRecord::Migration
  def change
    create_table :recipients do |t|
      t.integer :number
      t.integer :person_id
      t.integer :message_id

      t.timestamps
    end
    add_index :recipients, :number
    add_index :recipients, :person_id
    add_index :recipients, :message_id
  end
end