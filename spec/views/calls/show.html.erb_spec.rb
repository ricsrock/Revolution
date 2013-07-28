require 'spec_helper'

describe "calls/show" do
  before(:each) do
    @call = assign(:call, stub_model(Call,
      :from => "From",
      :to => "To",
      :sid => "Sid",
      :rec_sid => "Rec Sid",
      :rec_url => "Rec Url",
      :rec_duration => "Rec Duration",
      :for_user_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/From/)
    rendered.should match(/To/)
    rendered.should match(/Sid/)
    rendered.should match(/Rec Sid/)
    rendered.should match(/Rec Url/)
    rendered.should match(/Rec Duration/)
    rendered.should match(/1/)
  end
end
