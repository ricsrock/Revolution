FactoryGirl.define do
  factory :person do
    first_name { Faker::Name.first_name }
    gender { "Male" }
    default_group_id { 1 }
    association :household
  end
end