require 'spec_helper'

describe "leaderships/show" do
  before(:each) do
    @leadership = assign(:leadership, stub_model(Leadership,
      :leadable_id => 1,
      :leadable_type => "Leadable Type",
      :type => "Type",
      :person_id => 2,
      :title => "Title"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Leadable Type/)
    rendered.should match(/Type/)
    rendered.should match(/2/)
    rendered.should match(/Title/)
  end
end
