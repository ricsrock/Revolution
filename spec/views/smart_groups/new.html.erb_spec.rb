require 'spec_helper'

describe "smart_groups/new" do
  before(:each) do
    assign(:smart_group, stub_model(SmartGroup).as_new_record)
  end

  it "renders new smart_group form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", smart_groups_path, "post" do
    end
  end
end
