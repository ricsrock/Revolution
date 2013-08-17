class GeocoderWorker
  include Sidekiq::Worker
  # @queue = :geocoder_queue
  def perform(household_id)
    @household = Household.find(household_id)
    @household.geocode
    @household.save
  end
end