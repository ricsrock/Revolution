require 'spec_helper'

describe "smart_group_rules/edit" do
  before(:each) do
    @smart_group_rule = assign(:smart_group_rule, stub_model(SmartGroupRule))
  end

  it "renders the edit smart_group_rule form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", smart_group_rule_path(@smart_group_rule), "post" do
    end
  end
end
