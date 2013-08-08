# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Setup SmartGroup properties & operators...
SmartGroup.destroy_all
Operator.destroy_all
SmartGroupProperty.destroy_all

#create operators...
operators = [
    { short: 'after',   prose: 'after this many weeks ago'},
    { short: 'before',  prose: 'before this many weeks ago'},
    { short: 'between', prose: 'between'},
    { short: 'between', prose: 'between the following range of weeks'},
    { short: 'exactly', prose: 'exactly'},
    { short: 'greater', prose: 'greater than'},
    { short: 'less',    prose: 'less than'},
    { short: 'greater', prose: 'older than'},
    { short: 'between', prose: 'within this range of weeks'},
    { short: 'less',    prose: 'younger than'},
    { short: 'matches', prose: 'any part matches'}
  ]
  
operators.each do |attributes|
  o = Operator.new(attributes)
  o.save
end
  
properties = [
    { short: 'age', prose: 'whose age is', instructions: 'enter a number'},
    { short: 'attendance_status', prose: 'whose attendance status is', instructions: 'select'},
    { short: 'birthday', prose: 'whose birthday is this many months from now', instructions: '0 for this month, 1 for next month, etc...'},
    { short: 'connected', prose: 'who are connected', instructions: 'type true to return people who are either enrolled in any group or involved with any team; type false to find people who are neither'},
    { short: 'contr_count', prose: 'whose total number of contributions is', instructions: 'type a number or a range'},
    { short: 'created_date', prose: 'whose record was created', instructions: "enter a number or a range like,'2 and 6'"},
    { short: 'enrolled', prose: 'who are enrolled in any group', instructions: 'true or false'},
    { short: 'exclusive_tags', prose: 'who are tagged with', instructions: "comma-separated values work like 'AND'"},
    { short: 'first_attend', prose: 'whose first attend was', instructions: "enter a number or a range like, '2 and 4'"},
    { short: 'first_group_attend', prose: 'whose first group attend for', instructions: "choose a group then enter a number of weeks or a range like, '1 and 3'"},
    { short: 'gender', prose: 'whose gender is', instructions: "male or female"},
    { short: 'group_count', prose: 'whose total group attends for', instructions: "select and group, an operator, then enter a number of attends"},
    { short: 'have_group', prose: 'who are enrolled in group', instructions: "comma-separated group names work like 'OR'"},
    { short: 'have_tag', prose: 'who are tagged with', instructions: "comma-separated tag names work like 'OR'"},
    { short: 'household_position', prose: 'whose household position is', instructions: "comma-separated positon names work like 'OR'"},
    { short: 'involved', prose: 'who are involved with any ministry team', instructions: "true or false"},
    { short: 'mapped', prose: 'whose household address is mapped', instructions: "true or false"},
    { short: 'not_have_tag', prose: 'who are NOT tagged with', instructions: "enter one tag name"},
    { short: 'picture', prose: "who have a picture", instructions: "true or false"},
    { short: 'recent_attend', prose: "whose most recent attend was", instructions: "enter a number of weeks or a range like, '0 and 4'"},
    { short: 'recent_contr', prose: "whose most recent contribution was", instructions: nil},
    { short: 'recent_group_attend', prose: "whose most recent group attend for", instructions: "choose a group then enter a number of weeks or a range like, '1 and 3'"},
    { short: 'total_attends', prose: "whose total attends is", instructions: nil},
    { short: 'zip', prose: "whose household zip code is", instructions: "comma-separated zip code values work like 'OR'"}
  ]
  
properties.each do |p|
  s = SmartGroupProperty.new(p)
  s.save
end

after_this_many_weeks = Operator.find_by_prose('after this many weeks ago')
before_this_many_weeks = Operator.find_by_prose('before this many weeks ago')
between = Operator.find_by_prose('between')
between_range = Operator.find_by_prose('between the following range of weeks')
exactly = Operator.find_by_prose('exactly')
greater_than = Operator.find_by_prose('greater than')
less_than = Operator.find_by_prose('less than')
older_than = Operator.find_by_prose('older than')
within_this_range_of_weeks = Operator.find_by_prose('within this range of weeks')
younger_than = Operator.find_by_prose('younger than')
matches = Operator.find_by_prose('any part matches')

[older_than, exactly, younger_than].each do |v|
  SmartGroupProperty.find_by_short('age').operators << v
end

[before_this_many_weeks, after_this_many_weeks, between_range].each do |o|
  SmartGroupProperty.find_by_short('first_attend').operators << o
  SmartGroupProperty.find_by_short('first_group_attend').operators << o
  SmartGroupProperty.find_by_short('recent_group_attend').operators << o
  SmartGroupProperty.find_by_short('recent_attend').operators << o
  SmartGroupProperty.find_by_short('recent_contr').operators << o
  SmartGroupProperty.find_by_short('created_date').operators << o
end

[greater_than, less_than, exactly, between].each do |p|
  SmartGroupProperty.find_by_short('total_attends').operators << p
  SmartGroupProperty.find_by_short('group_count').operators << p
  SmartGroupProperty.find_by_short('contr_count').operators << p
end

o = Operator.where(:prose => "older than").first
o.update_attribute(:short, 'older')
o = Operator.where(:prose => "younger than").first
o.update_attribute(:short, 'younger')

o = Operator.new(prose: 'precisely', short: 'precisely')
o.save
# o = Operator.where(:prose => 'precisely').first
p = SmartGroupProperty.where(:short => 'age').first
exactly = Operator.where(:short => 'exactly').first
p.operators.delete(exactly)
p.operators << o
# end SmartGroup Setup

#Setup Interjections...
interjections = ["Bravo", "Congratulations", "Eureka", "Hallelujah", "Hot Dog", "Hurray", "Wahoo", "Woohoo", "Wow", "Yea", "Yippee"]
interjections.each do |w|
  i = Interjection.new(name: w, created_by: 'system', updated_by: 'system')
  i.save!
end
#end setup Interjections

# Setup RecordTypes for reports...
['Tags', 'Contacts', 'Contributions'].each do |r|
  RecordType.create(name: r)
end
#end setup RecordTypes

#Setup GroupBys...
record_type = RecordType.find_by_name("Tags")
record_type.group_bys.create(column_name: "Person")
record_type.group_bys.create(column_name: "Tag")

record_type = RecordType.find_by_name("Contacts")
["Person", "Contact Type"].each do |g|
  record_type.group_bys.create(column_name: g)
end

record_type = RecordType.find_by_name("Contributions")
["Person", "Fund"].each do |g|
  record_type.group_bys.create(column_name: g)
end


#Setup Layouts...
record_type = RecordType.find_by_name("Tags")
record_type.layouts.create(name: "Summary")
record_type.layouts.create(name: "Detail")
record_type = RecordType.find_by_name("Contacts")
record_type.layouts.create(name: "Summary")
record_type.layouts.create(name: "Detail")
record_type = RecordType.find_by_name("Contributions")
record_type.layouts.create(name: "Summary")
record_type.layouts.create(name: "Detail")

#Setup Permissions...
resources = %w[Contacts SmartGroups Groups Contributions Reports CheckinBackgrounds]
actions = %w[create read update destroy]

resources.each do |resource|
  actions.each do |action|
    p = Permission.new(resource_name: resource, ability_name: action, created_by: 'system')
    p.save
  end
end

#Setup Weekdays...
days = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
days.each do |d|
  w = Weekday.new(name: d)
  w.save
end

#Setup Cadences
cadences = ["weekly", "monthly", "every other week", "once each month"]
cadences.each do |c|
  r = Cadence.new(name: c)
  r.save
end

#Setup Admin role
role = Role.new(name: 'admin', alias: 'Administrator', description: 'Allows access to all functions in the system.')
role.save

#Setup initial user
user = User.new(first_name: 'Joe', last_name: 'Admin', login: 'jadmin', password: 'unsecure', password_confirmation: 'unsecure',
                email: 'joe@mydomain.com')
user.save
user.confirm!
admin = Role.find_by_name('admin')
user.roles << admin

#Setup essential tags
tag_group = TagGroup.new(name: 'Status Advance/Decline')
tag_group.save
tags = ["Guest Advance", "Guest Decline", "Inactive Advance", "Active Decline"]
tags.each do |tag|
  Tag.create(name: tag, tag_group_id: tag_group.id)
end

#Setup essential ContactTypes
contact_types = ["Missed You Letter", "Active At Risk", "Newcomer Call", "Guest Reception Invite", "1st Visit Letter", "2nd Visit Letter", "3rd Visit Letter"]
contact_types.each do |contact_type|
  ContactType.create(name: contact_type, default_responsible_user_id: User.find_by_login('jadmin').id)
end

#Setup CommTypes
types = %w[Home Work Mobile]
types.each do |type|
  CommType.create(name: type)
end

#Setup Animals...
animals = ['cheetah', 'kangaroo', 'hippopotamus', 'giraffe', 'puppy', 'aardvark', 'pony', 'tiger', 'lion', 'eagle', 'piglet', 'gecko', 'cobra', 'armadillo', 'dolphin', 'hedgehog', 'platypus', 'jaguar', 'goose',
            'porcupine', 'octopus', 'cricket', 'sword fish', 'sheep', 'panda', 'alligator', 'crocodile', 'bear', 'meerkat', 'zebra', 'lizard', 'turtle']
animals.each do |a|
  Animal.create(name: a)
end

#Setup Adjectives...
adjectives = ['jumping', 'funny', 'bouncy', 'silly', 'crazy', 'dancing', 'laughing', 'smiling', 'jolly', 'cute', 'fancy', 'dizzy', 'noisy', 'nutty',
              'playful', 'sparkling', 'spiffy', 'zany', 'tumbling', 'awesome', 'cuddly', 'skipping', 'singing', 'groovy', 'bubbly', 'curly',
              'joking', 'juggling', 'happy', 'heroic', 'charming', 'hilarious', 'courageous', 'witty', 'fabulous', 'whacky']
adjectives.each do |d|
  Adjective.create(name: d)
end

#Setup Colors...
colors = %w[yellow pink green magenta blue purple orange violet turquoise red aqua burgundy crimson emerald fuschia maroon lemon-lime
            melon golden hot-pink denim indigo polka-dot striped sapphire rasberry plum chartreuse peach periwinkle tangerine]
colors.each do |c|
  MyColor.create(name: c)
end


pp 'All done!'
pp 'You can login with username: jadmin, password: unsecure'


# Make sure you've validated uniqueness of any models for records added from here down... so you don't create dups when you re-run rake db:seed
p = SmartGroupProperty.new(short: 'household_name', prose: 'whose household name matches', instructions: 'type any part of a household name')
p.save




