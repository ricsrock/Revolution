require 'spec_helper'

describe "taggings/edit" do
  before(:each) do
    @tagging = assign(:tagging, stub_model(Tagging))
  end

  it "renders the edit tagging form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", tagging_path(@tagging), "post" do
    end
  end
end
