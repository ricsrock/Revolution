require 'spec_helper'

describe "follow_ups/index" do
  before(:each) do
    assign(:follow_ups, [
      stub_model(FollowUp,
        :notes => "MyText",
        :contact_id => 1,
        :created_by => "Created By",
        :updated_by => "Updated By",
        :follow_up_type_id => 2
      ),
      stub_model(FollowUp,
        :notes => "MyText",
        :contact_id => 1,
        :created_by => "Created By",
        :updated_by => "Updated By",
        :follow_up_type_id => 2
      )
    ])
  end

  it "renders a list of follow_ups" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Created By".to_s, :count => 2
    assert_select "tr>td", :text => "Updated By".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
