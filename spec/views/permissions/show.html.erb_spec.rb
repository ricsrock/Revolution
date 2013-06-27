require 'spec_helper'

describe "permissions/show" do
  before(:each) do
    @permission = assign(:permission, stub_model(Permission,
      :resource => "Resource",
      :action => "Action"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Resource/)
    rendered.should match(/Action/)
  end
end
