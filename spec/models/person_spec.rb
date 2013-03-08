require 'spec_helper'

describe Person do
  it "has a valid factory" do
    create(:person).should be_valid
  end
  it "is invalid without a first_name" do
    build(:person, first_name: nil).should_not be_valid
  end  
end