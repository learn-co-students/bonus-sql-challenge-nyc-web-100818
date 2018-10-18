# Parse the CSV and seed the database here! Run 'ruby db/seed' to execute this code.
require 'csv'

require_relative '../config/environment'

require_relative '../db/csv/csv_sqlite_builder'
require_relative '../db/csv/csv_column'

# SQLite reserved keywords can't be used for column names
KEYWORDS = []
File.readlines("./db/csv/sqlite_keywords.txt").each do |word|
  KEYWORDS << word.gsub(/[\r\n]+/,"")
end

# set up database connection
DB = {:conn => SQLite3::Database.open("./db/daily_show.db")}

# create table builder instance
table_builder = CsvSQLiteBuilder.new(csv_file_path: "./daily_show_guests.csv", table_name: "daily_show_guests", date_format: "%m/%d/%y")
table_builder.analyze(500) # analyze X rows to determine datatypes
table_builder.create_table # create table definition
table_builder.insert_row_data # insert row data to table
