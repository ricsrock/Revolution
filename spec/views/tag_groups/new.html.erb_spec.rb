require 'spec_helper'

describe "tag_groups/new" do
  before(:each) do
    assign(:tag_group, stub_model(TagGroup).as_new_record)
  end

  it "renders new tag_group form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", tag_groups_path, "post" do
    end
  end
end
