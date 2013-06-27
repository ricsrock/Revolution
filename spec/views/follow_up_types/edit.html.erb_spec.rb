require 'spec_helper'

describe "follow_up_types/edit" do
  before(:each) do
    @follow_up_type = assign(:follow_up_type, stub_model(FollowUpType,
      :name => "MyString"
    ))
  end

  it "renders the edit follow_up_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", follow_up_type_path(@follow_up_type), "post" do
      assert_select "input#follow_up_type_name[name=?]", "follow_up_type[name]"
    end
  end
end
