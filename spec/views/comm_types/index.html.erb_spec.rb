require 'spec_helper'

describe "comm_types/index" do
  before(:each) do
    assign(:comm_types, [
      stub_model(CommType),
      stub_model(CommType)
    ])
  end

  it "renders a list of comm_types" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
