require 'spec_helper'

describe "smart_groups/show" do
  before(:each) do
    @smart_group = assign(:smart_group, stub_model(SmartGroup))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
