require 'spec_helper'

describe "follow_up_types/show" do
  before(:each) do
    @follow_up_type = assign(:follow_up_type, stub_model(FollowUpType,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
