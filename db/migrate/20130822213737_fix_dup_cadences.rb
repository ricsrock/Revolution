class FixDupCadences < ActiveRecord::Migration
  def change
    
    cadence_names = ["weekly", "monthly", "every other week", "once each month"]
    cadence_names.each do |cadence|
      cadences = Cadence.where(name: cadence)
      while cadences.size > 1 do
        f = cadences.first
        l = cadences.last
        dups = Frequency.where(cadence_id: l.id)
        dups.each do |m| 
          m.update_attribute(:cadence_id, f.id)
          m.destroy
        end
        l.destroy
        cadences = Cadence.where(name: cadence)
      end
    end    
    
    
  end
end
