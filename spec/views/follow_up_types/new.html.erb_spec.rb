require 'spec_helper'

describe "follow_up_types/new" do
  before(:each) do
    assign(:follow_up_type, stub_model(FollowUpType,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new follow_up_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", follow_up_types_path, "post" do
      assert_select "input#follow_up_type_name[name=?]", "follow_up_type[name]"
    end
  end
end
