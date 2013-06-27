class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      #t.database_authenticatable :null => false
      rename_column :users, "crypted_password", "encrypted_password" # 5/28/13 - commented out to get migrations to run
      change_column :users, "encrypted_password", :string, :limit => 128, :default => "", :null => false
      rename_column :users, "salt", "password_salt" # 5/28/13 - commented out to get migrations to run
      change_column :users, "password_salt", :string, :default => "", :null => false
      #remove_column :users, :password_reset_code #5/28/13 - commented out to get migrations to run
      #remove_column :users, :remember_token
      #remove_column :users, :remember_token_expires_at
      
      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      #t.encryptable
      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      ## Token authenticatable
      t.string :authentication_token


     # t.timestamps
      
      #t.confirmable
      #t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      #t.token_authenticatable


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

