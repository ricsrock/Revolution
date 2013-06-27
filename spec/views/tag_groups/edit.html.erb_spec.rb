require 'spec_helper'

describe "tag_groups/edit" do
  before(:each) do
    @tag_group = assign(:tag_group, stub_model(TagGroup))
  end

  it "renders the edit tag_group form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", tag_group_path(@tag_group), "post" do
    end
  end
end
