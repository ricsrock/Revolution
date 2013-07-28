require 'spec_helper'

describe "sign_ups/index" do
  before(:each) do
    assign(:sign_ups, [
      stub_model(SignUp,
        :first_name => "First Name",
        :last_name => "Last Name",
        :gender => "Gender",
        :phone => "Phone"
      ),
      stub_model(SignUp,
        :first_name => "First Name",
        :last_name => "Last Name",
        :gender => "Gender",
        :phone => "Phone"
      )
    ])
  end

  it "renders a list of sign_ups" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => "Gender".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
  end
end
