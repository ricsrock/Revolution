require 'spec_helper'

describe "comm_types/new" do
  before(:each) do
    assign(:comm_type, stub_model(CommType).as_new_record)
  end

  it "renders new comm_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", comm_types_path, "post" do
    end
  end
end
