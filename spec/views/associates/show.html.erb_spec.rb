require 'spec_helper'

describe "associates/show" do
  before(:each) do
    @associate = assign(:associate, stub_model(Associate,
      :first_name => "First Name",
      :last_name => "Last Name",
      :comments => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/First Name/)
    rendered.should match(/Last Name/)
    rendered.should match(/MyText/)
  end
end
