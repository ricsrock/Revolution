require 'spec_helper'

describe "my_colors/index" do
  before(:each) do
    assign(:my_colors, [
      stub_model(MyColor,
        :name => "Name",
        :updated_by => "Updated By",
        :created_by => "Created By"
      ),
      stub_model(MyColor,
        :name => "Name",
        :updated_by => "Updated By",
        :created_by => "Created By"
      )
    ])
  end

  it "renders a list of my_colors" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Updated By".to_s, :count => 2
    assert_select "tr>td", :text => "Created By".to_s, :count => 2
  end
end
