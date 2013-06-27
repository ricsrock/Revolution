require 'spec_helper'

describe "contributions/show" do
  before(:each) do
    @contribution = assign(:contribution, stub_model(Contribution))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
