require 'spec_helper'

describe "contact_forms/edit" do
  before(:each) do
    @contact_form = assign(:contact_form, stub_model(ContactForm,
      :name => "MyString"
    ))
  end

  it "renders the edit contact_form form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", contact_form_path(@contact_form), "post" do
      assert_select "input#contact_form_name[name=?]", "contact_form[name]"
    end
  end
end
