require 'spec_helper'

describe "inquiries/new" do
  before(:each) do
    assign(:inquiry, stub_model(Inquiry,
      :person_id => 1,
      :group_id => 1,
      :created_by => "MyString",
      :updated_by => "MyString"
    ).as_new_record)
  end

  it "renders new inquiry form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", inquiries_path, "post" do
      assert_select "input#inquiry_person_id[name=?]", "inquiry[person_id]"
      assert_select "input#inquiry_group_id[name=?]", "inquiry[group_id]"
      assert_select "input#inquiry_created_by[name=?]", "inquiry[created_by]"
      assert_select "input#inquiry_updated_by[name=?]", "inquiry[updated_by]"
    end
  end
end
