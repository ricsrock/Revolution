require 'spec_helper'

describe "envolvements/new" do
  before(:each) do
    assign(:envolvement, stub_model(Envolvement).as_new_record)
  end

  it "renders new envolvement form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", envolvements_path, "post" do
    end
  end
end
