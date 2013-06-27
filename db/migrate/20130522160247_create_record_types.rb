class CreateRecordTypes < ActiveRecord::Migration
  def change
    create_table :record_types do |t|
      t.string :name

      t.timestamps
    end
    
    ['Tags', 'Contacts', 'Contributions'].each do |r|
      RecordType.create(name: r)
    end
    
  end
end
