require 'spec_helper'

describe "checkin_backgrounds/show" do
  before(:each) do
    @checkin_background = assign(:checkin_background, stub_model(CheckinBackground,
      :name => "Name",
      :graphic => "Graphic"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Graphic/)
  end
end
