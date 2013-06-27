require 'spec_helper'

describe "interjections/edit" do
  before(:each) do
    @interjection = assign(:interjection, stub_model(Interjection,
      :name => "MyString",
      :updated_by => "MyString",
      :created_by => "MyString"
    ))
  end

  it "renders the edit interjection form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", interjection_path(@interjection), "post" do
      assert_select "input#interjection_name[name=?]", "interjection[name]"
      assert_select "input#interjection_updated_by[name=?]", "interjection[updated_by]"
      assert_select "input#interjection_created_by[name=?]", "interjection[created_by]"
    end
  end
end
