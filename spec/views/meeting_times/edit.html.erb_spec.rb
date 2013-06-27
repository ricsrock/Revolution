require 'spec_helper'

describe "meeting_times/edit" do
  before(:each) do
    @meeting_time = assign(:meeting_time, stub_model(MeetingTime))
  end

  it "renders the edit meeting_time form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", meeting_time_path(@meeting_time), "post" do
    end
  end
end
