require 'spec_helper'

describe "adjectives/index" do
  before(:each) do
    assign(:adjectives, [
      stub_model(Adjective,
        :name => "Name",
        :updated_by => "Updated By",
        :created_by => "Created By"
      ),
      stub_model(Adjective,
        :name => "Name",
        :updated_by => "Updated By",
        :created_by => "Created By"
      )
    ])
  end

  it "renders a list of adjectives" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Updated By".to_s, :count => 2
    assert_select "tr>td", :text => "Created By".to_s, :count => 2
  end
end
