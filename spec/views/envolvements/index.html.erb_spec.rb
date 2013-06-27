require 'spec_helper'

describe "envolvements/index" do
  before(:each) do
    assign(:envolvements, [
      stub_model(Envolvement),
      stub_model(Envolvement)
    ])
  end

  it "renders a list of envolvements" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
