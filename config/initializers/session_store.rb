# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_doubanclient_session',
  :secret      => 'd1dd87aebb068c5257e63d50569301d37136f4a7b92ecc49b4b5783c04523cc727c1853b4433e48fa57894add8755da6266b25958cbab5bccc8c73da49b76e6e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
