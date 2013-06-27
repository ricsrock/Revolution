require 'spec_helper'

describe "leaderships/edit" do
  before(:each) do
    @leadership = assign(:leadership, stub_model(Leadership,
      :leadable_id => 1,
      :leadable_type => "MyString",
      :type => "",
      :person_id => 1,
      :title => "MyString"
    ))
  end

  it "renders the edit leadership form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", leadership_path(@leadership), "post" do
      assert_select "input#leadership_leadable_id[name=?]", "leadership[leadable_id]"
      assert_select "input#leadership_leadable_type[name=?]", "leadership[leadable_type]"
      assert_select "input#leadership_type[name=?]", "leadership[type]"
      assert_select "input#leadership_person_id[name=?]", "leadership[person_id]"
      assert_select "input#leadership_title[name=?]", "leadership[title]"
    end
  end
end
