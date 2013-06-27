require 'spec_helper'

describe "taggings/show" do
  before(:each) do
    @tagging = assign(:tagging, stub_model(Tagging))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
