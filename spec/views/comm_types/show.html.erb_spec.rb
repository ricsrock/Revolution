require 'spec_helper'

describe "comm_types/show" do
  before(:each) do
    @comm_type = assign(:comm_type, stub_model(CommType))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
