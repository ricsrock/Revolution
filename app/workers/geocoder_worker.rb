class GeocoderWorker
  @queue = :geocoder_queue
  def self.perform(household_id)
    @household = Household.find(household_id)
    @household.geocode
    @household.save
  end
end