require "spec_helper"

describe AnimalsController do
  describe "routing" do

    it "routes to #index" do
      get("/animals").should route_to("animals#index")
    end

    it "routes to #new" do
      get("/animals/new").should route_to("animals#new")
    end

    it "routes to #show" do
      get("/animals/1").should route_to("animals#show", :id => "1")
    end

    it "routes to #edit" do
      get("/animals/1/edit").should route_to("animals#edit", :id => "1")
    end

    it "routes to #create" do
      post("/animals").should route_to("animals#create")
    end

    it "routes to #update" do
      put("/animals/1").should route_to("animals#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/animals/1").should route_to("animals#destroy", :id => "1")
    end

  end
end
