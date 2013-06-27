require 'spec_helper'

describe "permissions/new" do
  before(:each) do
    assign(:permission, stub_model(Permission,
      :resource => "MyString",
      :action => "MyString"
    ).as_new_record)
  end

  it "renders new permission form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", permissions_path, "post" do
      assert_select "input#permission_resource[name=?]", "permission[resource]"
      assert_select "input#permission_action[name=?]", "permission[action]"
    end
  end
end
