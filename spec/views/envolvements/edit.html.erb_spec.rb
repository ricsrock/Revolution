require 'spec_helper'

describe "envolvements/edit" do
  before(:each) do
    @envolvement = assign(:envolvement, stub_model(Envolvement))
  end

  it "renders the edit envolvement form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", envolvement_path(@envolvement), "post" do
    end
  end
end
