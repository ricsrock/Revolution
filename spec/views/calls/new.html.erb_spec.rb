require 'spec_helper'

describe "calls/new" do
  before(:each) do
    assign(:call, stub_model(Call,
      :from => "MyString",
      :to => "MyString",
      :sid => "MyString",
      :rec_sid => "MyString",
      :rec_url => "MyString",
      :rec_duration => "MyString",
      :for_user_id => 1
    ).as_new_record)
  end

  it "renders new call form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", calls_path, "post" do
      assert_select "input#call_from[name=?]", "call[from]"
      assert_select "input#call_to[name=?]", "call[to]"
      assert_select "input#call_sid[name=?]", "call[sid]"
      assert_select "input#call_rec_sid[name=?]", "call[rec_sid]"
      assert_select "input#call_rec_url[name=?]", "call[rec_url]"
      assert_select "input#call_rec_duration[name=?]", "call[rec_duration]"
      assert_select "input#call_for_user_id[name=?]", "call[for_user_id]"
    end
  end
end
