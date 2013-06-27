require 'spec_helper'

describe "favorites/new" do
  before(:each) do
    assign(:favorite, stub_model(Favorite,
      :favoritable => "",
      :belongs_to => ""
    ).as_new_record)
  end

  it "renders new favorite form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", favorites_path, "post" do
      assert_select "input#favorite_favoritable[name=?]", "favorite[favoritable]"
      assert_select "input#favorite_belongs_to[name=?]", "favorite[belongs_to]"
    end
  end
end
