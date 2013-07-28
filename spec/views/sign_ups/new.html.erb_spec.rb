require 'spec_helper'

describe "sign_ups/new" do
  before(:each) do
    assign(:sign_up, stub_model(SignUp,
      :first_name => "MyString",
      :last_name => "MyString",
      :gender => "MyString",
      :phone => "MyString"
    ).as_new_record)
  end

  it "renders new sign_up form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", sign_ups_path, "post" do
      assert_select "input#sign_up_first_name[name=?]", "sign_up[first_name]"
      assert_select "input#sign_up_last_name[name=?]", "sign_up[last_name]"
      assert_select "input#sign_up_gender[name=?]", "sign_up[gender]"
      assert_select "input#sign_up_phone[name=?]", "sign_up[phone]"
    end
  end
end
