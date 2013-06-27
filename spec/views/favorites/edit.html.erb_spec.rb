require 'spec_helper'

describe "favorites/edit" do
  before(:each) do
    @favorite = assign(:favorite, stub_model(Favorite,
      :favoritable => "",
      :belongs_to => ""
    ))
  end

  it "renders the edit favorite form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", favorite_path(@favorite), "post" do
      assert_select "input#favorite_favoritable[name=?]", "favorite[favoritable]"
      assert_select "input#favorite_belongs_to[name=?]", "favorite[belongs_to]"
    end
  end
end
