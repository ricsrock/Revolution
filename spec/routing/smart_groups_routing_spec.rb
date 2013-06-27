require "spec_helper"

describe SmartGroupsController do
  describe "routing" do

    it "routes to #index" do
      get("/smart_groups").should route_to("smart_groups#index")
    end

    it "routes to #new" do
      get("/smart_groups/new").should route_to("smart_groups#new")
    end

    it "routes to #show" do
      get("/smart_groups/1").should route_to("smart_groups#show", :id => "1")
    end

    it "routes to #edit" do
      get("/smart_groups/1/edit").should route_to("smart_groups#edit", :id => "1")
    end

    it "routes to #create" do
      post("/smart_groups").should route_to("smart_groups#create")
    end

    it "routes to #update" do
      put("/smart_groups/1").should route_to("smart_groups#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/smart_groups/1").should route_to("smart_groups#destroy", :id => "1")
    end

  end
end
