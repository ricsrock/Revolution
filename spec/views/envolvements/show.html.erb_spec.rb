require 'spec_helper'

describe "envolvements/show" do
  before(:each) do
    @envolvement = assign(:envolvement, stub_model(Envolvement))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
