require 'spec_helper'

describe "batches/index" do
  before(:each) do
    assign(:batches, [
      stub_model(Batch),
      stub_model(Batch)
    ])
  end

  it "renders a list of batches" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
