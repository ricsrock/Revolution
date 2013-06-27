require 'spec_helper'

describe "adjectives/edit" do
  before(:each) do
    @adjective = assign(:adjective, stub_model(Adjective,
      :name => "MyString",
      :updated_by => "MyString",
      :created_by => "MyString"
    ))
  end

  it "renders the edit adjective form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", adjective_path(@adjective), "post" do
      assert_select "input#adjective_name[name=?]", "adjective[name]"
      assert_select "input#adjective_updated_by[name=?]", "adjective[updated_by]"
      assert_select "input#adjective_created_by[name=?]", "adjective[created_by]"
    end
  end
end
