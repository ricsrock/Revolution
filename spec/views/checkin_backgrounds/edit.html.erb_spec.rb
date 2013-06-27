require 'spec_helper'

describe "checkin_backgrounds/edit" do
  before(:each) do
    @checkin_background = assign(:checkin_background, stub_model(CheckinBackground,
      :name => "MyString",
      :graphic => "MyString"
    ))
  end

  it "renders the edit checkin_background form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", checkin_background_path(@checkin_background), "post" do
      assert_select "input#checkin_background_name[name=?]", "checkin_background[name]"
      assert_select "input#checkin_background_graphic[name=?]", "checkin_background[graphic]"
    end
  end
end
