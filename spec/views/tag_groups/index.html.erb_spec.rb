require 'spec_helper'

describe "tag_groups/index" do
  before(:each) do
    assign(:tag_groups, [
      stub_model(TagGroup),
      stub_model(TagGroup)
    ])
  end

  it "renders a list of tag_groups" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
