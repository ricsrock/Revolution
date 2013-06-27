require 'spec_helper'

describe "contributions/new" do
  before(:each) do
    assign(:contribution, stub_model(Contribution).as_new_record)
  end

  it "renders new contribution form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", contributions_path, "post" do
    end
  end
end
