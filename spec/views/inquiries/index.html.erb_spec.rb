require 'spec_helper'

describe "inquiries/index" do
  before(:each) do
    assign(:inquiries, [
      stub_model(Inquiry,
        :person_id => 1,
        :group_id => 2,
        :created_by => "Created By",
        :updated_by => "Updated By"
      ),
      stub_model(Inquiry,
        :person_id => 1,
        :group_id => 2,
        :created_by => "Created By",
        :updated_by => "Updated By"
      )
    ])
  end

  it "renders a list of inquiries" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Created By".to_s, :count => 2
    assert_select "tr>td", :text => "Updated By".to_s, :count => 2
  end
end
