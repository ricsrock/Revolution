class CreateSms < ActiveRecord::Migration
  def self.up
        create_table :sms_setups do |t|
          t.column :carrier_name, :string
          t.column :config, :string
          t.column :created_at, :datetime
          t.column :updated_at, :datetime
          t.column :created_by, :string
          t.column :updated_by, :string
        end
        
        add_column :phones, :sms_setup_id, :integer
  end

  def self.down
        drop_table :sms_setups
  end
end
