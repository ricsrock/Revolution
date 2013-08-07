class FixWhitespace < ActiveRecord::Migration
  def change
    Household.all.each do |h|
      h.update_attribute(:name, h.name.strip)
    end
  end
end
