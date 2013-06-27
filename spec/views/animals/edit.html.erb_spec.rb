require 'spec_helper'

describe "animals/edit" do
  before(:each) do
    @animal = assign(:animal, stub_model(Animal,
      :name => "MyString",
      :updated_by => "MyString",
      :created_by => "MyString"
    ))
  end

  it "renders the edit animal form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", animal_path(@animal), "post" do
      assert_select "input#animal_name[name=?]", "animal[name]"
      assert_select "input#animal_updated_by[name=?]", "animal[updated_by]"
      assert_select "input#animal_created_by[name=?]", "animal[created_by]"
    end
  end
end
