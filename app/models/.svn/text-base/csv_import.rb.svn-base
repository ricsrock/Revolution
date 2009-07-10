 require 'csv'
 require 'active_record'
  
 db = ActiveRecord::Base.establish_connection(
  :adapter =>  'sqlserver',
  :database => 'web',
  :username => 'user',
  :password => 'secret',
  :host => 'hostname'
)
 
class Demo < ActiveRecord::Base
  set_table_name 'SeminarLocations'
end
 
row_count = 0
CSV::Reader.parse(File.open("c:\\data\\demos.csv", "rb")) do |row|
  row_count += 1
  puts "parsing row #{row_count}"
  city_state = row[1].split(', ')
  event_city = city_state[0]
  event_state = city_state[1]
  address = row[3].to_s.split('**')
  csz = address[1].split(', ')
  city = csz[0]
  state_zip= csz[1].split(' ')
  state = state_zip[0]
  zip = state_zip[1]
  
  params = {
    :Date => row[0],
    :EventCity => event_city,
    :EventState => event_state,
    :Hotel => row[2],
    :Address => address[0],
    :City => city,
    :State => state,
    :Zip => zip,
    :Phone => row[4],
    :url => row[5]
  }
  puts "done parsing, now to insert into database"
  Demo.create!(params)
  puts "done parsing row #{row_count}"
end 

