require "spec_helper"

describe BatchesController do
  describe "routing" do

    it "routes to #index" do
      get("/batches").should route_to("batches#index")
    end

    it "routes to #new" do
      get("/batches/new").should route_to("batches#new")
    end

    it "routes to #show" do
      get("/batches/1").should route_to("batches#show", :id => "1")
    end

    it "routes to #edit" do
      get("/batches/1/edit").should route_to("batches#edit", :id => "1")
    end

    it "routes to #create" do
      post("/batches").should route_to("batches#create")
    end

    it "routes to #update" do
      put("/batches/1").should route_to("batches#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/batches/1").should route_to("batches#destroy", :id => "1")
    end

  end
end
