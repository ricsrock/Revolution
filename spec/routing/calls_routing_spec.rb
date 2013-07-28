require "spec_helper"

describe CallsController do
  describe "routing" do

    it "routes to #index" do
      get("/calls").should route_to("calls#index")
    end

    it "routes to #new" do
      get("/calls/new").should route_to("calls#new")
    end

    it "routes to #show" do
      get("/calls/1").should route_to("calls#show", :id => "1")
    end

    it "routes to #edit" do
      get("/calls/1/edit").should route_to("calls#edit", :id => "1")
    end

    it "routes to #create" do
      post("/calls").should route_to("calls#create")
    end

    it "routes to #update" do
      put("/calls/1").should route_to("calls#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/calls/1").should route_to("calls#destroy", :id => "1")
    end

  end
end
