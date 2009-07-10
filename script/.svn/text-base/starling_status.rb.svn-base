require 'pp'

puts '=> Loading Rails...'

require File.dirname(__FILE__) + '/../config/environment'
require File.dirname(__FILE__) + '/../vendor/plugins/workling/lib/workling/starling/poller'
require File.dirname(__FILE__) + '/../vendor/plugins/workling/lib/workling/starling/routing/class_and_method_routing'

puts '** Rails loaded.'

trap(:INT) { exit }

begin
  client = Workling::Starling::Client.new
  client.reset
  
  client.stats # do this so that connection is shown as established below. 
  
  puts "Queue state:"
  pp client.inspect
  pp "Active?: #{client.active?}"
  pp "Read Only?: #{client.readonly?}"
  puts ""
  puts "Servers:"
  pp client.servers
  puts ""
  puts "Queue stats:"
  pp client.stats

  puts "\nThread Stats:"
  pp Thread.list
ensure
  puts '** Exiting'
end