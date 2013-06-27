require 'spec_helper'

describe "batches/edit" do
  before(:each) do
    @batch = assign(:batch, stub_model(Batch))
  end

  it "renders the edit batch form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", batch_path(@batch), "post" do
    end
  end
end
