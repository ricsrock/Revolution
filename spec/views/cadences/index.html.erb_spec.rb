require 'spec_helper'

describe "cadences/index" do
  before(:each) do
    assign(:cadences, [
      stub_model(Cadence,
        :name => "Name"
      ),
      stub_model(Cadence,
        :name => "Name"
      )
    ])
  end

  it "renders a list of cadences" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
