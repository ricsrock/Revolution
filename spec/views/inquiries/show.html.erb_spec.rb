require 'spec_helper'

describe "inquiries/show" do
  before(:each) do
    @inquiry = assign(:inquiry, stub_model(Inquiry,
      :person_id => 1,
      :group_id => 2,
      :created_by => "Created By",
      :updated_by => "Updated By"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/Created By/)
    rendered.should match(/Updated By/)
  end
end
