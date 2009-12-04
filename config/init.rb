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
dependency 'dm-core'
dependency 'data_objects'
dependency 'dm-types'
dependency 'dm-migrations'
# dependency 'dm-validations'

dependency 'sqlite3', :gem => 'sqlite3-ruby', :env => :development

dependency 'do_sqlite3', :env => :development
dependency 'do_postgres', :env => :production

# Fires up a connection to the database using settings from config/database.yml config
Cilantro.setup_database
