require 'spec_helper'

describe "smart_groups/edit" do
  before(:each) do
    @smart_group = assign(:smart_group, stub_model(SmartGroup))
  end

  it "renders the edit smart_group form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", smart_group_path(@smart_group), "post" do
    end
  end
end
