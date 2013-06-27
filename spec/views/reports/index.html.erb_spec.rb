require 'spec_helper'

describe "reports/index" do
  before(:each) do
    assign(:reports, [
      stub_model(Report,
        :name => "Name",
        :record_type_id => 1,
        :group_by => "Group By",
        :parameters => "MyText",
        :layout => "Layout",
        :created_by => "Created By",
        :updated_by => "Updated By"
      ),
      stub_model(Report,
        :name => "Name",
        :record_type_id => 1,
        :group_by => "Group By",
        :parameters => "MyText",
        :layout => "Layout",
        :created_by => "Created By",
        :updated_by => "Updated By"
      )
    ])
  end

  it "renders a list of reports" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Group By".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Layout".to_s, :count => 2
    assert_select "tr>td", :text => "Created By".to_s, :count => 2
    assert_select "tr>td", :text => "Updated By".to_s, :count => 2
  end
end
