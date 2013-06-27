require 'spec_helper'

describe "permissions/index" do
  before(:each) do
    assign(:permissions, [
      stub_model(Permission,
        :resource => "Resource",
        :action => "Action"
      ),
      stub_model(Permission,
        :resource => "Resource",
        :action => "Action"
      )
    ])
  end

  it "renders a list of permissions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Resource".to_s, :count => 2
    assert_select "tr>td", :text => "Action".to_s, :count => 2
  end
end
