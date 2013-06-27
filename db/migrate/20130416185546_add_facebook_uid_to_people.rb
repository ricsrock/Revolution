class AddFacebookUidToPeople < ActiveRecord::Migration
  def change
    add_column :people, :facebook_uid, :string
    add_column :people, :facebook_url, :string
  end
end
