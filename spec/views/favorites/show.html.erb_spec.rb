require 'spec_helper'

describe "favorites/show" do
  before(:each) do
    @favorite = assign(:favorite, stub_model(Favorite,
      :favoritable => "",
      :belongs_to => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
  end
end
