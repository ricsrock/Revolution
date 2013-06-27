require 'spec_helper'

describe "contacts/edit" do
  before(:each) do
    @contact = assign(:contact, stub_model(Contact,
      :contact_type_id => 1,
      :person_id => 1,
      :responsible_user_id => 1,
      :comments => "MyText"
    ))
  end

  it "renders the edit contact form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", contact_path(@contact), "post" do
      assert_select "input#contact_contact_type_id[name=?]", "contact[contact_type_id]"
      assert_select "input#contact_person_id[name=?]", "contact[person_id]"
      assert_select "input#contact_responsible_user_id[name=?]", "contact[responsible_user_id]"
      assert_select "textarea#contact_comments[name=?]", "contact[comments]"
    end
  end
end
