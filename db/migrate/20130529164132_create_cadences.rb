class CreateCadences < ActiveRecord::Migration
  def change
    create_table :cadences do |t|
      t.string :name
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
    add_index :cadences, :name
    
    cadences = ["weekly", "monthly", "every other week", "once each month"]
    cadences.each do |c|
      r = Cadence.new(name: c)
      r.save
    end
    
  end
end