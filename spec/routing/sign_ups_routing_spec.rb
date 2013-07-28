require "spec_helper"

describe SignUpsController do
  describe "routing" do

    it "routes to #index" do
      get("/sign_ups").should route_to("sign_ups#index")
    end

    it "routes to #new" do
      get("/sign_ups/new").should route_to("sign_ups#new")
    end

    it "routes to #show" do
      get("/sign_ups/1").should route_to("sign_ups#show", :id => "1")
    end

    it "routes to #edit" do
      get("/sign_ups/1/edit").should route_to("sign_ups#edit", :id => "1")
    end

    it "routes to #create" do
      post("/sign_ups").should route_to("sign_ups#create")
    end

    it "routes to #update" do
      put("/sign_ups/1").should route_to("sign_ups#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/sign_ups/1").should route_to("sign_ups#destroy", :id => "1")
    end

  end
end
