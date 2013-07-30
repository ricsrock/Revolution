class AddAudioToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :audio, :string
  end
end
