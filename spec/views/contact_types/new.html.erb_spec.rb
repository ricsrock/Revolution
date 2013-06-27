require 'spec_helper'

describe "contact_types/new" do
  before(:each) do
    assign(:contact_type, stub_model(ContactType,
      :name => "MyString",
      :default_responsible_user_id => 1,
      :default_responsible_ministry_id => 1,
      :multiple_close => false,
      :notiphy => false
    ).as_new_record)
  end

  it "renders new contact_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", contact_types_path, "post" do
      assert_select "input#contact_type_name[name=?]", "contact_type[name]"
      assert_select "input#contact_type_default_responsible_user_id[name=?]", "contact_type[default_responsible_user_id]"
      assert_select "input#contact_type_default_responsible_ministry_id[name=?]", "contact_type[default_responsible_ministry_id]"
      assert_select "input#contact_type_multiple_close[name=?]", "contact_type[multiple_close]"
      assert_select "input#contact_type_notiphy[name=?]", "contact_type[notiphy]"
    end
  end
end
