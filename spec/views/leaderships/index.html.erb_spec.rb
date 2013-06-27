require 'spec_helper'

describe "leaderships/index" do
  before(:each) do
    assign(:leaderships, [
      stub_model(Leadership,
        :leadable_id => 1,
        :leadable_type => "Leadable Type",
        :type => "Type",
        :person_id => 2,
        :title => "Title"
      ),
      stub_model(Leadership,
        :leadable_id => 1,
        :leadable_type => "Leadable Type",
        :type => "Type",
        :person_id => 2,
        :title => "Title"
      )
    ])
  end

  it "renders a list of leaderships" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Leadable Type".to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
  end
end
