class SetEventNames < ActiveRecord::Migration
  def change
    events = Event.all
    events.each do |v|
      v.update_attribute(:name, v.set_name)
    end
  end
end
