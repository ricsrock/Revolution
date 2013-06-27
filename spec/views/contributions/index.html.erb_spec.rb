require 'spec_helper'

describe "contributions/index" do
  before(:each) do
    assign(:contributions, [
      stub_model(Contribution),
      stub_model(Contribution)
    ])
  end

  it "renders a list of contributions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
