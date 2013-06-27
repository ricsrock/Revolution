require "spec_helper"

describe TaggingsController do
  describe "routing" do

    it "routes to #index" do
      get("/taggings").should route_to("taggings#index")
    end

    it "routes to #new" do
      get("/taggings/new").should route_to("taggings#new")
    end

    it "routes to #show" do
      get("/taggings/1").should route_to("taggings#show", :id => "1")
    end

    it "routes to #edit" do
      get("/taggings/1/edit").should route_to("taggings#edit", :id => "1")
    end

    it "routes to #create" do
      post("/taggings").should route_to("taggings#create")
    end

    it "routes to #update" do
      put("/taggings/1").should route_to("taggings#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/taggings/1").should route_to("taggings#destroy", :id => "1")
    end

  end
end
