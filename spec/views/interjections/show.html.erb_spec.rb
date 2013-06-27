require 'spec_helper'

describe "interjections/show" do
  before(:each) do
    @interjection = assign(:interjection, stub_model(Interjection,
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
