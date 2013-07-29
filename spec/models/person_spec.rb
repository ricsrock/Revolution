require 'spec_helper'

describe Person do
  it "has a valid factory" do
    create(:person).should be_valid
  end
  it "is invalid without a first_name" do
    build(:person, first_name: nil).should_not be_valid
  end
  it "is invalid without a household_id" do
    build(:person, household_id: nil).should_not be_valid
  end
  it "is invalid without a gender assignment" do
    build(:person, gender: nil).should_not be_valid
  end
  it "is invalid without a default_group_id" do
    build(:person, default_group_id: nil).should_not be_valid
  end
  it "is has attendance status of 'Guest'" do
    person = create(:person)
    expect(person.attendance_status).to eq('Guest')
    person.attendance_status = 'Funky'
    expect(person).to be_invalid
  end
  
  
end