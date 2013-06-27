require 'spec_helper'

describe "funds/new" do
  before(:each) do
    assign(:fund, stub_model(Fund).as_new_record)
  end

  it "renders new fund form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", funds_path, "post" do
    end
  end
end
