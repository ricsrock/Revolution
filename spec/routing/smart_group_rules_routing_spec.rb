require "spec_helper"

describe SmartGroupRulesController do
  describe "routing" do

    it "routes to #index" do
      get("/smart_group_rules").should route_to("smart_group_rules#index")
    end

    it "routes to #new" do
      get("/smart_group_rules/new").should route_to("smart_group_rules#new")
    end

    it "routes to #show" do
      get("/smart_group_rules/1").should route_to("smart_group_rules#show", :id => "1")
    end

    it "routes to #edit" do
      get("/smart_group_rules/1/edit").should route_to("smart_group_rules#edit", :id => "1")
    end

    it "routes to #create" do
      post("/smart_group_rules").should route_to("smart_group_rules#create")
    end

    it "routes to #update" do
      put("/smart_group_rules/1").should route_to("smart_group_rules#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/smart_group_rules/1").should route_to("smart_group_rules#destroy", :id => "1")
    end

  end
end
