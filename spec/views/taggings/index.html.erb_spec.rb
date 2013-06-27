require 'spec_helper'

describe "taggings/index" do
  before(:each) do
    assign(:taggings, [
      stub_model(Tagging),
      stub_model(Tagging)
    ])
  end

  it "renders a list of taggings" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
