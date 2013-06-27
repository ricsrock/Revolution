require 'spec_helper'

describe "follow_ups/show" do
  before(:each) do
    @follow_up = assign(:follow_up, stub_model(FollowUp,
      :notes => "MyText",
      :contact_id => 1,
      :created_by => "Created By",
      :updated_by => "Updated By",
      :follow_up_type_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    rendered.should match(/1/)
    rendered.should match(/Created By/)
    rendered.should match(/Updated By/)
    rendered.should match(/2/)
  end
end
