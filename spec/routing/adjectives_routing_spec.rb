require "spec_helper"

describe AdjectivesController do
  describe "routing" do

    it "routes to #index" do
      get("/adjectives").should route_to("adjectives#index")
    end

    it "routes to #new" do
      get("/adjectives/new").should route_to("adjectives#new")
    end

    it "routes to #show" do
      get("/adjectives/1").should route_to("adjectives#show", :id => "1")
    end

    it "routes to #edit" do
      get("/adjectives/1/edit").should route_to("adjectives#edit", :id => "1")
    end

    it "routes to #create" do
      post("/adjectives").should route_to("adjectives#create")
    end

    it "routes to #update" do
      put("/adjectives/1").should route_to("adjectives#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/adjectives/1").should route_to("adjectives#destroy", :id => "1")
    end

  end
end
