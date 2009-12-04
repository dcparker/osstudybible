# File: config/init.rb
# Sets up configurations and includes gems, libraries, controllers & models.
# To start the web server, use bin/cilantro.
# 
# To be loaded ONLY by Cilantro.load_environment. These things are already done at this point:
#   + ./lib is included in the ruby load path
#   + rubygems is loaded, but sandboxed to ./gems if ./gems exists
#   + if we're running in server or test mode, sinatra has been loaded


###################
# Section: Options
# Set your Cilantro options here.
Cilantro.auto_reload = false


###################
# Section: Dependencies and Libraries
require 'cilantro/templater'


###################
# Section: Database Setup
# Fires up a connection to the database using settings from config/database.yml config
require_with_auto_install 'sqlite3', :gem => 'sqlite3-ruby'
require_with_auto_install 'do_sqlite3'
require_with_auto_install 'dm-core'
require_with_auto_install 'data_objects'
require_with_auto_install 'dm-types'
require_with_auto_install 'dm-migrations'
# require_with_auto_install 'dm-validations'
Cilantro.setup_database
