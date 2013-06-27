require 'spec_helper'

describe "meeting_times/new" do
  before(:each) do
    assign(:meeting_time, stub_model(MeetingTime).as_new_record)
  end

  it "renders new meeting_time form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", meeting_times_path, "post" do
    end
  end
end
