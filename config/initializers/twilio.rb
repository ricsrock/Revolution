# APP_CONFIG = YAML.load_file("#{Rails.root}/config/initializers/config.yml")[RAILS_ENV]
# CONFIG = YAML.load(File.read(File.expand_path('../config.yml', __FILE__)))
# CONFIG.merge! CONFIG.fetch(Rails.env, {})
# CONFIG.symbolize_keys!


Twilio::Config.setup :account_sid  => 'AC00a8989c9bb872af122b5ad9636b7347', :auth_token   => '9efbb468e830bac7a7582627e643222f'