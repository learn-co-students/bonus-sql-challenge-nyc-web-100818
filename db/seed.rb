# Parse the CSV and seed the database here! Run 'ruby db/seed' to execute this code.
require 'csv'
require 'pry'
daily_show_guests = CSV.read('daily_show_guests.csv')

def parse(data)

  limit = data.length
  year = Array.new
  googleknowlege_occupation = Array.new
  show = Array.new
  group = Array.new
  raw_guest_list = Array.new
  parsed_array = Array.new

  for i in (1...data.size)
    year << data[i][0]
  end
  for i in (1...data.size)
    googleknowlege_occupation << data[i][1]
  end
  for i in (1...data.size)
    show << data[i][2]
  end
  for i in (1...data.size)
    group << data[i][3]
  end
  for i in (1...data.size)
    raw_guest_list << data[i][4]
  end
  parsed_array.push(year, googleknowlege_occupation, show, group, raw_guest_list)
  parsed_array

end #end of parse method

binding.pry

parse(daily_show_guests)
# puts daily_show_guests[1][0]
