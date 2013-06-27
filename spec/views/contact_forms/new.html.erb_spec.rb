require 'spec_helper'

describe "contact_forms/new" do
  before(:each) do
    assign(:contact_form, stub_model(ContactForm,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new contact_form form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", contact_forms_path, "post" do
      assert_select "input#contact_form_name[name=?]", "contact_form[name]"
    end
  end
end
