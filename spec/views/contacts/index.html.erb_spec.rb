require 'spec_helper'

describe "contacts/index" do
  before(:each) do
    assign(:contacts, [
      stub_model(Contact,
        :contact_type_id => 1,
        :person_id => 2,
        :responsible_user_id => 3,
        :comments => "MyText"
      ),
      stub_model(Contact,
        :contact_type_id => 1,
        :person_id => 2,
        :responsible_user_id => 3,
        :comments => "MyText"
      )
    ])
  end

  it "renders a list of contacts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
