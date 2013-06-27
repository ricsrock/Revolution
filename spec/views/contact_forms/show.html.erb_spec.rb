require 'spec_helper'

describe "contact_forms/show" do
  before(:each) do
    @contact_form = assign(:contact_form, stub_model(ContactForm,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
