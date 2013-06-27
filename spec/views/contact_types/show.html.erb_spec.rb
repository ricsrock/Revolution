require 'spec_helper'

describe "contact_types/show" do
  before(:each) do
    @contact_type = assign(:contact_type, stub_model(ContactType,
      :name => "Name",
      :default_responsible_user_id => 1,
      :default_responsible_ministry_id => 2,
      :multiple_close => false,
      :notiphy => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/false/)
    rendered.should match(/false/)
  end
end
