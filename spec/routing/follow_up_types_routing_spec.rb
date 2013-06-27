require "spec_helper"

describe FollowUpTypesController do
  describe "routing" do

    it "routes to #index" do
      get("/follow_up_types").should route_to("follow_up_types#index")
    end

    it "routes to #new" do
      get("/follow_up_types/new").should route_to("follow_up_types#new")
    end

    it "routes to #show" do
      get("/follow_up_types/1").should route_to("follow_up_types#show", :id => "1")
    end

    it "routes to #edit" do
      get("/follow_up_types/1/edit").should route_to("follow_up_types#edit", :id => "1")
    end

    it "routes to #create" do
      post("/follow_up_types").should route_to("follow_up_types#create")
    end

    it "routes to #update" do
      put("/follow_up_types/1").should route_to("follow_up_types#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/follow_up_types/1").should route_to("follow_up_types#destroy", :id => "1")
    end

  end
end
