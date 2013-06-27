require 'spec_helper'

describe "organizations/edit" do
  before(:each) do
    @organization = assign(:organization, stub_model(Organization,
      :name => "MyString",
      :address1 => "MyString",
      :address => "",
      :city => "MyString",
      :state => "MyString",
      :zip => 1
    ))
  end

  it "renders the edit organization form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", organization_path(@organization), "post" do
      assert_select "input#organization_name[name=?]", "organization[name]"
      assert_select "input#organization_address1[name=?]", "organization[address1]"
      assert_select "input#organization_address[name=?]", "organization[address]"
      assert_select "input#organization_city[name=?]", "organization[city]"
      assert_select "input#organization_state[name=?]", "organization[state]"
      assert_select "input#organization_zip[name=?]", "organization[zip]"
    end
  end
end
