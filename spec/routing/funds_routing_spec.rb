require "spec_helper"

describe FundsController do
  describe "routing" do

    it "routes to #index" do
      get("/funds").should route_to("funds#index")
    end

    it "routes to #new" do
      get("/funds/new").should route_to("funds#new")
    end

    it "routes to #show" do
      get("/funds/1").should route_to("funds#show", :id => "1")
    end

    it "routes to #edit" do
      get("/funds/1/edit").should route_to("funds#edit", :id => "1")
    end

    it "routes to #create" do
      post("/funds").should route_to("funds#create")
    end

    it "routes to #update" do
      put("/funds/1").should route_to("funds#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/funds/1").should route_to("funds#destroy", :id => "1")
    end

  end
end
