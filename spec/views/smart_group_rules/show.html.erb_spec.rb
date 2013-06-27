require 'spec_helper'

describe "smart_group_rules/show" do
  before(:each) do
    @smart_group_rule = assign(:smart_group_rule, stub_model(SmartGroupRule))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
