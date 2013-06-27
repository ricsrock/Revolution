require "spec_helper"

describe FollowUpsController do
  describe "routing" do

    it "routes to #index" do
      get("/follow_ups").should route_to("follow_ups#index")
    end

    it "routes to #new" do
      get("/follow_ups/new").should route_to("follow_ups#new")
    end

    it "routes to #show" do
      get("/follow_ups/1").should route_to("follow_ups#show", :id => "1")
    end

    it "routes to #edit" do
      get("/follow_ups/1/edit").should route_to("follow_ups#edit", :id => "1")
    end

    it "routes to #create" do
      post("/follow_ups").should route_to("follow_ups#create")
    end

    it "routes to #update" do
      put("/follow_ups/1").should route_to("follow_ups#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/follow_ups/1").should route_to("follow_ups#destroy", :id => "1")
    end

  end
end
