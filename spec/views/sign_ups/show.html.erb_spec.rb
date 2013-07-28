require 'spec_helper'

describe "sign_ups/show" do
  before(:each) do
    @sign_up = assign(:sign_up, stub_model(SignUp,
      :first_name => "First Name",
      :last_name => "Last Name",
      :gender => "Gender",
      :phone => "Phone"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/First Name/)
    rendered.should match(/Last Name/)
    rendered.should match(/Gender/)
    rendered.should match(/Phone/)
  end
end
