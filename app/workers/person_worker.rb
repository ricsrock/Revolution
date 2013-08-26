class PersonWorker
  include Sidekiq::Worker
  # @queue = :geocoder_queue
  def perform(person_id)
    @person = Person.find(person_id)
    @person.set_first_attend
    @person.set_recent_attend
  end
end