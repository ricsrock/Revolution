require 'spec_helper'

describe "comm_types/edit" do
  before(:each) do
    @comm_type = assign(:comm_type, stub_model(CommType))
  end

  it "renders the edit comm_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", comm_type_path(@comm_type), "post" do
    end
  end
end
