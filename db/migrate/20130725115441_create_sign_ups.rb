class CreateSignUps < ActiveRecord::Migration
  def change
    create_table :sign_ups do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.string :phone
      t.string :step
      t.timestamps
    end
  end
end
