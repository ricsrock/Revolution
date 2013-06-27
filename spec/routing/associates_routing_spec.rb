require "spec_helper"

describe AssociatesController do
  describe "routing" do

    it "routes to #index" do
      get("/associates").should route_to("associates#index")
    end

    it "routes to #new" do
      get("/associates/new").should route_to("associates#new")
    end

    it "routes to #show" do
      get("/associates/1").should route_to("associates#show", :id => "1")
    end

    it "routes to #edit" do
      get("/associates/1/edit").should route_to("associates#edit", :id => "1")
    end

    it "routes to #create" do
      post("/associates").should route_to("associates#create")
    end

    it "routes to #update" do
      put("/associates/1").should route_to("associates#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/associates/1").should route_to("associates#destroy", :id => "1")
    end

  end
end
