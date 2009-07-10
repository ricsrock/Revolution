class Households < ActiveRecord::Migration
  def self.up
    create_table :households do |t|
      t.column :name, :string
      t.column :address1, :string
      t.column :address2, :string
      t.column :city, :string
      t.column :state, :string
    end
  end

  def self.down
    drop_table :households
  end
end
