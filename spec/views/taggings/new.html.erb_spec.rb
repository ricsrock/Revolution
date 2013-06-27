require 'spec_helper'

describe "taggings/new" do
  before(:each) do
    assign(:tagging, stub_model(Tagging).as_new_record)
  end

  it "renders new tagging form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", taggings_path, "post" do
    end
  end
end
