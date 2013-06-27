require "spec_helper"

describe CheckinBackgroundsController do
  describe "routing" do

    it "routes to #index" do
      get("/checkin_backgrounds").should route_to("checkin_backgrounds#index")
    end

    it "routes to #new" do
      get("/checkin_backgrounds/new").should route_to("checkin_backgrounds#new")
    end

    it "routes to #show" do
      get("/checkin_backgrounds/1").should route_to("checkin_backgrounds#show", :id => "1")
    end

    it "routes to #edit" do
      get("/checkin_backgrounds/1/edit").should route_to("checkin_backgrounds#edit", :id => "1")
    end

    it "routes to #create" do
      post("/checkin_backgrounds").should route_to("checkin_backgrounds#create")
    end

    it "routes to #update" do
      put("/checkin_backgrounds/1").should route_to("checkin_backgrounds#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/checkin_backgrounds/1").should route_to("checkin_backgrounds#destroy", :id => "1")
    end

  end
end
