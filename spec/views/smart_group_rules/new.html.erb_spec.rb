require 'spec_helper'

describe "smart_group_rules/new" do
  before(:each) do
    assign(:smart_group_rule, stub_model(SmartGroupRule).as_new_record)
  end

  it "renders new smart_group_rule form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", smart_group_rules_path, "post" do
    end
  end
end
