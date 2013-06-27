class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :to
      t.integer :from
      t.text :body
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end
