require 'spec_helper'

describe "checkin_backgrounds/index" do
  before(:each) do
    assign(:checkin_backgrounds, [
      stub_model(CheckinBackground,
        :name => "Name",
        :graphic => "Graphic"
      ),
      stub_model(CheckinBackground,
        :name => "Name",
        :graphic => "Graphic"
      )
    ])
  end

  it "renders a list of checkin_backgrounds" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Graphic".to_s, :count => 2
  end
end
