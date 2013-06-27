require 'spec_helper'

describe "cadences/new" do
  before(:each) do
    assign(:cadence, stub_model(Cadence,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new cadence form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", cadences_path, "post" do
      assert_select "input#cadence_name[name=?]", "cadence[name]"
    end
  end
end
