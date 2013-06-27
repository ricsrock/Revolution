require 'spec_helper'

describe "enrollments/index" do
  before(:each) do
    assign(:enrollments, [
      stub_model(Enrollment),
      stub_model(Enrollment)
    ])
  end

  it "renders a list of enrollments" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
