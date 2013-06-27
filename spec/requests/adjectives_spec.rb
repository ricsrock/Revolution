require 'spec_helper'

describe "Adjectives" do
  describe "GET /adjectives" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get adjectives_path
      response.status.should be(200)
    end
  end
end
