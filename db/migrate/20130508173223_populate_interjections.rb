class PopulateInterjections < ActiveRecord::Migration
  def change
    interjections = ["Bravo", "Congratulations", "Eureka", "Hallelujah", "Hot Dog", "Hurray", "Wahoo", "Woohoo", "Wow", "Yea", "Yippee"]
    interjections.each do |w|
      i = Interjection.new(name: w, created_by: 'lkenyan', updated_by: 'lkenyan')
      i.save!
    end
  end
end
