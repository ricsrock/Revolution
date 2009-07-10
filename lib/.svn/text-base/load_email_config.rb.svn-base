
  c = YAML::load(File.open("#{RAILS_ROOT}/config/email.yml"))
  ActionMailer::Base.smtp_settings = {
    :address => c[RAILS_ENV]['address'],
    :port => c[RAILS_ENV]['port'],
    :domain => c[RAILS_ENV]['domain'],
    :authentication => c[RAILS_ENV]['authentication'],
    :user_name => c[RAILS_ENV]['username'],
    :password => c[RAILS_ENV]['password']
  }