require "spec_helper"

describe EnvolvementsController do
  describe "routing" do

    it "routes to #index" do
      get("/envolvements").should route_to("envolvements#index")
    end

    it "routes to #new" do
      get("/envolvements/new").should route_to("envolvements#new")
    end

    it "routes to #show" do
      get("/envolvements/1").should route_to("envolvements#show", :id => "1")
    end

    it "routes to #edit" do
      get("/envolvements/1/edit").should route_to("envolvements#edit", :id => "1")
    end

    it "routes to #create" do
      post("/envolvements").should route_to("envolvements#create")
    end

    it "routes to #update" do
      put("/envolvements/1").should route_to("envolvements#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/envolvements/1").should route_to("envolvements#destroy", :id => "1")
    end

  end
end
