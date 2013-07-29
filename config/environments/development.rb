NewrevF::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL).
  #config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  config.assets.debug = true
  
  config.assets.prefix = "/dev-assets"
  config.assets.js_compressor  = :uglifier
  
  config.action_mailer.perform_deliveries = false
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp  
  ActionMailer::Base.smtp_settings = {
    :port           => 587, 
    :address        => 'smtp.mailgun.org',
    :user_name      => 'postmaster@local.rivervalleychurch.net',
    :password       => Figaro.env.mailgun_pwd,
    :domain         => 'local.rivervalleychurch.net',
    :authentication => :plain,
  }
  
  
  config.middleware.use ExceptionNotifier,
    :email => {
      :email_prefix => "[RevolutionError] ",
      :sender_address => %{"donotreply" <donotreply@local.rivervalleychurch.net>},
      :exception_recipients => %w{lowell@rivervalleychurch.net}
    }
  
  Delayed::Worker.logger = Rails.logger
  
end

