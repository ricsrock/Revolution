namespace :test do
  desc "TODO"
  task email: :environment do
    GroupMailer.test.deliver!
    Rails.logger.info " ======= sending test email, done ========= "
  end

end
