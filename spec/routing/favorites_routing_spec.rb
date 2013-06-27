require "spec_helper"

describe FavoritesController do
  describe "routing" do

    it "routes to #index" do
      get("/favorites").should route_to("favorites#index")
    end

    it "routes to #new" do
      get("/favorites/new").should route_to("favorites#new")
    end

    it "routes to #show" do
      get("/favorites/1").should route_to("favorites#show", :id => "1")
    end

    it "routes to #edit" do
      get("/favorites/1/edit").should route_to("favorites#edit", :id => "1")
    end

    it "routes to #create" do
      post("/favorites").should route_to("favorites#create")
    end

    it "routes to #update" do
      put("/favorites/1").should route_to("favorites#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/favorites/1").should route_to("favorites#destroy", :id => "1")
    end

  end
end
