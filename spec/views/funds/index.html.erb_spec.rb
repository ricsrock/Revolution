require 'spec_helper'

describe "funds/index" do
  before(:each) do
    assign(:funds, [
      stub_model(Fund),
      stub_model(Fund)
    ])
  end

  it "renders a list of funds" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
