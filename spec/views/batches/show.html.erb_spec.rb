require 'spec_helper'

describe "batches/show" do
  before(:each) do
    @batch = assign(:batch, stub_model(Batch))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
