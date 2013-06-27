require 'spec_helper'

describe "reports/show" do
  before(:each) do
    @report = assign(:report, stub_model(Report,
      :name => "Name",
      :record_type_id => 1,
      :group_by => "Group By",
      :parameters => "MyText",
      :layout => "Layout",
      :created_by => "Created By",
      :updated_by => "Updated By"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/1/)
    rendered.should match(/Group By/)
    rendered.should match(/MyText/)
    rendered.should match(/Layout/)
    rendered.should match(/Created By/)
    rendered.should match(/Updated By/)
  end
end
