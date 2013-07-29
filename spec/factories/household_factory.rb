FactoryGirl.define do
  factory :household do
    name { Faker::Name.last_name }
    address1 { Faker::Address.street_name }
    address2 { Faker::Address.street_name }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip { Faker::Address.zip }
  end
end