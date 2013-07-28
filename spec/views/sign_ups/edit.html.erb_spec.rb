require 'spec_helper'

describe "sign_ups/edit" do
  before(:each) do
    @sign_up = assign(:sign_up, stub_model(SignUp,
      :first_name => "MyString",
      :last_name => "MyString",
      :gender => "MyString",
      :phone => "MyString"
    ))
  end

  it "renders the edit sign_up form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", sign_up_path(@sign_up), "post" do
      assert_select "input#sign_up_first_name[name=?]", "sign_up[first_name]"
      assert_select "input#sign_up_last_name[name=?]", "sign_up[last_name]"
      assert_select "input#sign_up_gender[name=?]", "sign_up[gender]"
      assert_select "input#sign_up_phone[name=?]", "sign_up[phone]"
    end
  end
end
