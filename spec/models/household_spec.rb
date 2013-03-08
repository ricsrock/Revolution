require 'spec_helper'

describe Household do
  it "has a valid factory" do
    create(:household).should be_valid
  end
  it "is invalid without a name" do
    build(:household, name: nil).should_not be_valid
  end  
end