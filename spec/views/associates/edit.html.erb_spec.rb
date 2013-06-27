require 'spec_helper'

describe "associates/edit" do
  before(:each) do
    @associate = assign(:associate, stub_model(Associate,
      :first_name => "MyString",
      :last_name => "MyString",
      :comments => "MyText"
    ))
  end

  it "renders the edit associate form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", associate_path(@associate), "post" do
      assert_select "input#associate_first_name[name=?]", "associate[first_name]"
      assert_select "input#associate_last_name[name=?]", "associate[last_name]"
      assert_select "textarea#associate_comments[name=?]", "associate[comments]"
    end
  end
end
