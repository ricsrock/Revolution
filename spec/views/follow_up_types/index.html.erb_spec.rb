require 'spec_helper'

describe "follow_up_types/index" do
  before(:each) do
    assign(:follow_up_types, [
      stub_model(FollowUpType,
        :name => "Name"
      ),
      stub_model(FollowUpType,
        :name => "Name"
      )
    ])
  end

  it "renders a list of follow_up_types" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
