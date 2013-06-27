class AddConfidentialToContactTypes < ActiveRecord::Migration
  def change
    add_column :contact_types, :confidential, :boolean
  end
end
