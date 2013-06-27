require 'spec_helper'

describe "my_colors/new" do
  before(:each) do
    assign(:my_color, stub_model(MyColor,
      :name => "MyString",
      :updated_by => "MyString",
      :created_by => "MyString"
    ).as_new_record)
  end

  it "renders new my_color form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", my_colors_path, "post" do
      assert_select "input#my_color_name[name=?]", "my_color[name]"
      assert_select "input#my_color_updated_by[name=?]", "my_color[updated_by]"
      assert_select "input#my_color_created_by[name=?]", "my_color[created_by]"
    end
  end
end
