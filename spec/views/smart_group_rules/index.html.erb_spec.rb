require 'spec_helper'

describe "smart_group_rules/index" do
  before(:each) do
    assign(:smart_group_rules, [
      stub_model(SmartGroupRule),
      stub_model(SmartGroupRule)
    ])
  end

  it "renders a list of smart_group_rules" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
