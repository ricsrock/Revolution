class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      #t.database_authenticatable :null => false
      rename_column :users, "crypted_password", "encrypted_password"
      change_column :users, "encrypted_password", :string, :limit => 128, :default => "", :null => false
      rename_column :users, "salt", "password_salt"
      change_column :users, "password_salt", :string, :default => "", :null => false
      remove_column :users, :password_reset_code
      remove_column :users, :remember_token
      remove_column :users, :remember_token_expires_at
      t.recoverable
      t.rememberable
      t.trackable

      #t.encryptable
      t.confirmable
      t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      t.token_authenticatable


      # t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :confirmation_token,   :unique => true
    add_index :users, :unlock_token,         :unique => true
    add_index :users, :authentication_token, :unique => true
  end

  def self.down
    #drop_table :users
  end
end

