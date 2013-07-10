class EmailWorker
  @queue = :email_queue
  def self.perform
    GroupMailer.test.deliver!
  end
end