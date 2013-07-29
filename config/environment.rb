# Load the rails application.
require File.expand_path('../application', __FILE__)

# Initialize the rails application.
Revolution::Application.initialize!

include NamedDateRanges
