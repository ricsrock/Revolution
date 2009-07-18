# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :session_key => '_b_session',
  :secret      => '08a74db50d82d5cd065bc6f25e11c189d5e96cb06eb564b851e40b322cbcc822df0bb32808b0fe5e8aecca92b90386d04763dd7cf22d4ff4c68968cdc4d647a5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store