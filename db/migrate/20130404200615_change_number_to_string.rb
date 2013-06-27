class ChangeNumberToString < ActiveRecord::Migration
  def change
    change_column :recipients, :number, :string
  end
end
