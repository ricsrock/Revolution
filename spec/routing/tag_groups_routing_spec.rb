require "spec_helper"

describe TagGroupsController do
  describe "routing" do

    it "routes to #index" do
      get("/tag_groups").should route_to("tag_groups#index")
    end

    it "routes to #new" do
      get("/tag_groups/new").should route_to("tag_groups#new")
    end

    it "routes to #show" do
      get("/tag_groups/1").should route_to("tag_groups#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tag_groups/1/edit").should route_to("tag_groups#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tag_groups").should route_to("tag_groups#create")
    end

    it "routes to #update" do
      put("/tag_groups/1").should route_to("tag_groups#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tag_groups/1").should route_to("tag_groups#destroy", :id => "1")
    end

  end
end
