require "spec_helper"

describe InterjectionsController do
  describe "routing" do

    it "routes to #index" do
      get("/interjections").should route_to("interjections#index")
    end

    it "routes to #new" do
      get("/interjections/new").should route_to("interjections#new")
    end

    it "routes to #show" do
      get("/interjections/1").should route_to("interjections#show", :id => "1")
    end

    it "routes to #edit" do
      get("/interjections/1/edit").should route_to("interjections#edit", :id => "1")
    end

    it "routes to #create" do
      post("/interjections").should route_to("interjections#create")
    end

    it "routes to #update" do
      put("/interjections/1").should route_to("interjections#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/interjections/1").should route_to("interjections#destroy", :id => "1")
    end

  end
end
