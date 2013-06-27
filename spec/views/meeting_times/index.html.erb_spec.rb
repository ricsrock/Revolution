require 'spec_helper'

describe "meeting_times/index" do
  before(:each) do
    assign(:meeting_times, [
      stub_model(MeetingTime),
      stub_model(MeetingTime)
    ])
  end

  it "renders a list of meeting_times" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
