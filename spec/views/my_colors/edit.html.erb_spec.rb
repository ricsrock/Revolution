require 'spec_helper'

describe "my_colors/edit" do
  before(:each) do
    @my_color = assign(:my_color, stub_model(MyColor,
      :name => "MyString",
      :updated_by => "MyString",
      :created_by => "MyString"
    ))
  end

  it "renders the edit my_color form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", my_color_path(@my_color), "post" do
      assert_select "input#my_color_name[name=?]", "my_color[name]"
      assert_select "input#my_color_updated_by[name=?]", "my_color[updated_by]"
      assert_select "input#my_color_created_by[name=?]", "my_color[created_by]"
    end
  end
end
