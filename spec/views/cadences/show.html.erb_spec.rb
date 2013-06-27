require 'spec_helper'

describe "cadences/show" do
  before(:each) do
    @cadence = assign(:cadence, stub_model(Cadence,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
