# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_gmsplus_session',
  :secret      => '2307e4de20bbddbb7284991d6a445b27d2190563b534adfdccd60c667a99f302645c5b47525c6839509070b2b7b0e0a6874355b4a549f9fcdf20b88826e5c51b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
