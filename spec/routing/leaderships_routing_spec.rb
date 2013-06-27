require "spec_helper"

describe LeadershipsController do
  describe "routing" do

    it "routes to #index" do
      get("/leaderships").should route_to("leaderships#index")
    end

    it "routes to #new" do
      get("/leaderships/new").should route_to("leaderships#new")
    end

    it "routes to #show" do
      get("/leaderships/1").should route_to("leaderships#show", :id => "1")
    end

    it "routes to #edit" do
      get("/leaderships/1/edit").should route_to("leaderships#edit", :id => "1")
    end

    it "routes to #create" do
      post("/leaderships").should route_to("leaderships#create")
    end

    it "routes to #update" do
      put("/leaderships/1").should route_to("leaderships#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/leaderships/1").should route_to("leaderships#destroy", :id => "1")
    end

  end
end
