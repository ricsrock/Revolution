require 'spec_helper'

describe "interjections/new" do
  before(:each) do
    assign(:interjection, stub_model(Interjection,
      :name => "MyString",
      :updated_by => "MyString",
      :created_by => "MyString"
    ).as_new_record)
  end

  it "renders new interjection form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", interjections_path, "post" do
      assert_select "input#interjection_name[name=?]", "interjection[name]"
      assert_select "input#interjection_updated_by[name=?]", "interjection[updated_by]"
      assert_select "input#interjection_created_by[name=?]", "interjection[created_by]"
    end
  end
end
