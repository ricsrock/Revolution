require 'spec_helper'

describe "meeting_times/show" do
  before(:each) do
    @meeting_time = assign(:meeting_time, stub_model(MeetingTime))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
