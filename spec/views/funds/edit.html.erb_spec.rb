require 'spec_helper'

describe "funds/edit" do
  before(:each) do
    @fund = assign(:fund, stub_model(Fund))
  end

  it "renders the edit fund form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", fund_path(@fund), "post" do
    end
  end
end
