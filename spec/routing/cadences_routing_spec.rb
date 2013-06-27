require "spec_helper"

describe CadencesController do
  describe "routing" do

    it "routes to #index" do
      get("/cadences").should route_to("cadences#index")
    end

    it "routes to #new" do
      get("/cadences/new").should route_to("cadences#new")
    end

    it "routes to #show" do
      get("/cadences/1").should route_to("cadences#show", :id => "1")
    end

    it "routes to #edit" do
      get("/cadences/1/edit").should route_to("cadences#edit", :id => "1")
    end

    it "routes to #create" do
      post("/cadences").should route_to("cadences#create")
    end

    it "routes to #update" do
      put("/cadences/1").should route_to("cadences#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/cadences/1").should route_to("cadences#destroy", :id => "1")
    end

  end
end
