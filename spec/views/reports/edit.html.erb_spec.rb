require 'spec_helper'

describe "reports/edit" do
  before(:each) do
    @report = assign(:report, stub_model(Report,
      :name => "MyString",
      :record_type_id => 1,
      :group_by => "MyString",
      :parameters => "MyText",
      :layout => "MyString",
      :created_by => "MyString",
      :updated_by => "MyString"
    ))
  end

  it "renders the edit report form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", report_path(@report), "post" do
      assert_select "input#report_name[name=?]", "report[name]"
      assert_select "input#report_record_type_id[name=?]", "report[record_type_id]"
      assert_select "input#report_group_by[name=?]", "report[group_by]"
      assert_select "textarea#report_parameters[name=?]", "report[parameters]"
      assert_select "input#report_layout[name=?]", "report[layout]"
      assert_select "input#report_created_by[name=?]", "report[created_by]"
      assert_select "input#report_updated_by[name=?]", "report[updated_by]"
    end
  end
end
