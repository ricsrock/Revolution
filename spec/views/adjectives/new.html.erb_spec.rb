require 'spec_helper'

describe "adjectives/new" do
  before(:each) do
    assign(:adjective, stub_model(Adjective,
      :name => "MyString",
      :updated_by => "MyString",
      :created_by => "MyString"
    ).as_new_record)
  end

  it "renders new adjective form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", adjectives_path, "post" do
      assert_select "input#adjective_name[name=?]", "adjective[name]"
      assert_select "input#adjective_updated_by[name=?]", "adjective[updated_by]"
      assert_select "input#adjective_created_by[name=?]", "adjective[created_by]"
    end
  end
end
