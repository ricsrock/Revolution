# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # You have to specify the :lib option for libraries, where the Gem name (sqlite3-ruby) differs from the file itself (sqlite3)
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Comment line to use default local time.
  config.time_zone = 'UTC'

  # The internationalization framework can be changed to have another default locale (standard is :en) or more load paths.
  # All files from config/locales/*.rb,yml are added automatically.
  # config.i18n.load_path << Dir[File.join(RAILS_ROOT, 'my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_new-2-2-2-app_session',
    :secret      => '08a74db50d82d5cd065bc6f25e11c189d5e96cb06eb564b851e40b322cbcc822df0bb32808b0fe5e8aecca92b90386d04763dd7cf22d4ff4c68968cdc4d647a5'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # Please note that observers generated using script/generate observer need to have an _observer suffix
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
  config.active_record.observers = :meeting_observer, :user_observer
  

  require 'vpim/vcard'
  #require 'gruff'
  #require 'RMagick.rb'
  require 'memcache'
  #require 'starling'
  #require 'setting'

  # Load email configuration
  #require 'load_email_config'


  class Date
    def to_time(form = :local)
      ::Time.send("#{form}", year, month, day)
    end

    def qtr
      month = self.strftime('%m').to_i
      case month
      when (1..3)
        '1'
      when (4..6)
        '2'
      when (7..9)
        '3'
      when (10..12)
        '4'
      end
    end

    def year_qtr
      year = self.strftime('%Y')
      year + '-' + self.qtr
    end
  end


  class Time
      def end_of_day
          change(:hour => 23, :min => 59, :sec => 59)
      end

      def end_of_week
        days_to_sunday = self.wday!=0 ? 7-self.wday : 0
        (self + days_to_sunday.days).end_of_day
      end

  end

  class Array
     def to_hash_keys(&block)
       Hash[*self.collect { |v|
         [v, block.call(v)]
       }.flatten]
     end

     def to_hash_values(&block)
       Hash[*self.collect { |v|
         [block.call(v), v]
       }.flatten]
     end

     def extract_options!
       last.is_a?(::Hash) ? pop : {}
     end
  end

  class Hash
    def except(*keys)
       dup.except!(*keys)
     end
    def except!(*keys)
     keys.map! { |key| convert_key(key) } if respond_to?(:convert_key)
     keys.each { |key| delete(key) }
     self
   end

   def slice(*keys)
      keys = keys.map! { |key| convert_key(key) } if respond_to?(:convert_key)
      hash = self.class.new
      keys.each { |k| hash[k] = self[k] if has_key?(k) }
      hash
    end

    def slice!(*keys)
        replace(slice(*keys))
      end
  end

  #Workling::Remote.dispatcher = Workling::Remote::Runners::StarlingRunner.new
  
  
end
