require 'spec_helper'

describe "calls/index" do
  before(:each) do
    assign(:calls, [
      stub_model(Call,
        :from => "From",
        :to => "To",
        :sid => "Sid",
        :rec_sid => "Rec Sid",
        :rec_url => "Rec Url",
        :rec_duration => "Rec Duration",
        :for_user_id => 1
      ),
      stub_model(Call,
        :from => "From",
        :to => "To",
        :sid => "Sid",
        :rec_sid => "Rec Sid",
        :rec_url => "Rec Url",
        :rec_duration => "Rec Duration",
        :for_user_id => 1
      )
    ])
  end

  it "renders a list of calls" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "From".to_s, :count => 2
    assert_select "tr>td", :text => "To".to_s, :count => 2
    assert_select "tr>td", :text => "Sid".to_s, :count => 2
    assert_select "tr>td", :text => "Rec Sid".to_s, :count => 2
    assert_select "tr>td", :text => "Rec Url".to_s, :count => 2
    assert_select "tr>td", :text => "Rec Duration".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
