require 'spec_helper'

describe "tag_groups/show" do
  before(:each) do
    @tag_group = assign(:tag_group, stub_model(TagGroup))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
