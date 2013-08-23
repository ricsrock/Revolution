class AddLockedAtAndFieldTypeToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :locked_at, :datetime
    add_column :settings, :field_type, :string
  end
end
