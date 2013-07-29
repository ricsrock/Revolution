# APP_CONFIG = YAML.load_file("#{Rails.root}/config/initializers/config.yml")[RAILS_ENV]
# CONFIG = YAML.load(File.read(File.expand_path('../config.yml', __FILE__)))
# CONFIG.merge! CONFIG.fetch(Rails.env, {})
# CONFIG.symbolize_keys!


Twilio::Config.setup :account_sid  => Figaro.env.twilio_account_sid, :auth_token   => Figaro.env.twilio_auth_token