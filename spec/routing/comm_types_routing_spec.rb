require "spec_helper"

describe CommTypesController do
  describe "routing" do

    it "routes to #index" do
      get("/comm_types").should route_to("comm_types#index")
    end

    it "routes to #new" do
      get("/comm_types/new").should route_to("comm_types#new")
    end

    it "routes to #show" do
      get("/comm_types/1").should route_to("comm_types#show", :id => "1")
    end

    it "routes to #edit" do
      get("/comm_types/1/edit").should route_to("comm_types#edit", :id => "1")
    end

    it "routes to #create" do
      post("/comm_types").should route_to("comm_types#create")
    end

    it "routes to #update" do
      put("/comm_types/1").should route_to("comm_types#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/comm_types/1").should route_to("comm_types#destroy", :id => "1")
    end

  end
end
