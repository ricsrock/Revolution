class AddSuppressStickersToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :suppress_stickers, :boolean, default: false
    
    Group.all.update_all(suppress_stickers: false)
  end
end
