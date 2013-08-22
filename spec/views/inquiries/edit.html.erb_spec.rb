require 'spec_helper'

describe "inquiries/edit" do
  before(:each) do
    @inquiry = assign(:inquiry, stub_model(Inquiry,
      :person_id => 1,
      :group_id => 1,
      :created_by => "MyString",
      :updated_by => "MyString"
    ))
  end

  it "renders the edit inquiry form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", inquiry_path(@inquiry), "post" do
      assert_select "input#inquiry_person_id[name=?]", "inquiry[person_id]"
      assert_select "input#inquiry_group_id[name=?]", "inquiry[group_id]"
      assert_select "input#inquiry_created_by[name=?]", "inquiry[created_by]"
      assert_select "input#inquiry_updated_by[name=?]", "inquiry[updated_by]"
    end
  end
end
