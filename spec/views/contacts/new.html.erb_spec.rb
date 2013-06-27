require 'spec_helper'

describe "contacts/new" do
  before(:each) do
    assign(:contact, stub_model(Contact,
      :contact_type_id => 1,
      :person_id => 1,
      :responsible_user_id => 1,
      :comments => "MyText"
    ).as_new_record)
  end

  it "renders new contact form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", contacts_path, "post" do
      assert_select "input#contact_contact_type_id[name=?]", "contact[contact_type_id]"
      assert_select "input#contact_person_id[name=?]", "contact[person_id]"
      assert_select "input#contact_responsible_user_id[name=?]", "contact[responsible_user_id]"
      assert_select "textarea#contact_comments[name=?]", "contact[comments]"
    end
  end
end
