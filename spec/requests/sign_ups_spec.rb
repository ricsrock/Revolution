require 'spec_helper'

describe "SignUps" do
  describe "GET /sign_ups" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get sign_ups_path
      response.status.should be(200)
    end
  end
end
