require 'spec_helper'

describe "checkin_backgrounds/new" do
  before(:each) do
    assign(:checkin_background, stub_model(CheckinBackground,
      :name => "MyString",
      :graphic => "MyString"
    ).as_new_record)
  end

  it "renders new checkin_background form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", checkin_backgrounds_path, "post" do
      assert_select "input#checkin_background_name[name=?]", "checkin_background[name]"
      assert_select "input#checkin_background_graphic[name=?]", "checkin_background[graphic]"
    end
  end
end
