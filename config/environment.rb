require 'bundler/setup'
require 'base64'

Bundler.require

require_relative '../lib/queries'

# set up database connection
DB = {:conn => SQLite3::Database.open("./db/daily_show.db")}

# rake console will hit pry!
