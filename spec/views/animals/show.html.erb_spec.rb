require 'spec_helper'

describe "animals/show" do
  before(:each) do
    @animal = assign(:animal, stub_model(Animal,
      :name => "Name",
      :updated_by => "Updated By",
      :created_by => "Created By"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Updated By/)
    rendered.should match(/Created By/)
  end
end
