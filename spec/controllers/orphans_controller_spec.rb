require 'spec_helper'

describe OrphansController do

  describe "GET 'people'" do
    it "returns http success" do
      get 'people'
      response.should be_success
    end
  end

end
