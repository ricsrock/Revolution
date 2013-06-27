require 'spec_helper'

describe "smart_groups/index" do
  before(:each) do
    assign(:smart_groups, [
      stub_model(SmartGroup),
      stub_model(SmartGroup)
    ])
  end

  it "renders a list of smart_groups" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
