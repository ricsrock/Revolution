require 'spec_helper'

describe "favorites/index" do
  before(:each) do
    assign(:favorites, [
      stub_model(Favorite,
        :favoritable => "",
        :belongs_to => ""
      ),
      stub_model(Favorite,
        :favoritable => "",
        :belongs_to => ""
      )
    ])
  end

  it "renders a list of favorites" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
