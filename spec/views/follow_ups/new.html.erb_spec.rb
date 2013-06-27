require 'spec_helper'

describe "follow_ups/new" do
  before(:each) do
    assign(:follow_up, stub_model(FollowUp,
      :notes => "MyText",
      :contact_id => 1,
      :created_by => "MyString",
      :updated_by => "MyString",
      :follow_up_type_id => 1
    ).as_new_record)
  end

  it "renders new follow_up form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", follow_ups_path, "post" do
      assert_select "textarea#follow_up_notes[name=?]", "follow_up[notes]"
      assert_select "input#follow_up_contact_id[name=?]", "follow_up[contact_id]"
      assert_select "input#follow_up_created_by[name=?]", "follow_up[created_by]"
      assert_select "input#follow_up_updated_by[name=?]", "follow_up[updated_by]"
      assert_select "input#follow_up_follow_up_type_id[name=?]", "follow_up[follow_up_type_id]"
    end
  end
end
