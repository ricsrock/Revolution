require 'spec_helper'

describe "SmartGroupRules" do
  describe "GET /smart_group_rules" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get smart_group_rules_path
      response.status.should be(200)
    end
  end
end
