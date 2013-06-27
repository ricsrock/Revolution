require 'spec_helper'

describe "animals/new" do
  before(:each) do
    assign(:animal, stub_model(Animal,
      :name => "MyString",
      :updated_by => "MyString",
      :created_by => "MyString"
    ).as_new_record)
  end

  it "renders new animal form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", animals_path, "post" do
      assert_select "input#animal_name[name=?]", "animal[name]"
      assert_select "input#animal_updated_by[name=?]", "animal[updated_by]"
      assert_select "input#animal_created_by[name=?]", "animal[created_by]"
    end
  end
end
