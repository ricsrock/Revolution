require 'spec_helper'

describe "cadences/edit" do
  before(:each) do
    @cadence = assign(:cadence, stub_model(Cadence,
      :name => "MyString"
    ))
  end

  it "renders the edit cadence form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", cadence_path(@cadence), "post" do
      assert_select "input#cadence_name[name=?]", "cadence[name]"
    end
  end
end
