require 'spec_helper'

describe "associates/index" do
  before(:each) do
    assign(:associates, [
      stub_model(Associate,
        :first_name => "First Name",
        :last_name => "Last Name",
        :comments => "MyText"
      ),
      stub_model(Associate,
        :first_name => "First Name",
        :last_name => "Last Name",
        :comments => "MyText"
      )
    ])
  end

  it "renders a list of associates" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
