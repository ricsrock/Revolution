require 'spec_helper'

describe "contact_types/index" do
  before(:each) do
    assign(:contact_types, [
      stub_model(ContactType,
        :name => "Name",
        :default_responsible_user_id => 1,
        :default_responsible_ministry_id => 2,
        :multiple_close => false,
        :notiphy => false
      ),
      stub_model(ContactType,
        :name => "Name",
        :default_responsible_user_id => 1,
        :default_responsible_ministry_id => 2,
        :multiple_close => false,
        :notiphy => false
      )
    ])
  end

  it "renders a list of contact_types" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
