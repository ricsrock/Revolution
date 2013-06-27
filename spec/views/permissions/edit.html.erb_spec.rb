require 'spec_helper'

describe "permissions/edit" do
  before(:each) do
    @permission = assign(:permission, stub_model(Permission,
      :resource => "MyString",
      :action => "MyString"
    ))
  end

  it "renders the edit permission form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", permission_path(@permission), "post" do
      assert_select "input#permission_resource[name=?]", "permission[resource]"
      assert_select "input#permission_action[name=?]", "permission[action]"
    end
  end
end
