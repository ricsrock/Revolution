require 'spec_helper'

describe "organizations/show" do
  before(:each) do
    @organization = assign(:organization, stub_model(Organization,
      :name => "Name",
      :address1 => "Address1",
      :address => "",
      :city => "City",
      :state => "State",
      :zip => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Address1/)
    rendered.should match(//)
    rendered.should match(/City/)
    rendered.should match(/State/)
    rendered.should match(/1/)
  end
end
