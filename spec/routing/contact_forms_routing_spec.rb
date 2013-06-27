require "spec_helper"

describe ContactFormsController do
  describe "routing" do

    it "routes to #index" do
      get("/contact_forms").should route_to("contact_forms#index")
    end

    it "routes to #new" do
      get("/contact_forms/new").should route_to("contact_forms#new")
    end

    it "routes to #show" do
      get("/contact_forms/1").should route_to("contact_forms#show", :id => "1")
    end

    it "routes to #edit" do
      get("/contact_forms/1/edit").should route_to("contact_forms#edit", :id => "1")
    end

    it "routes to #create" do
      post("/contact_forms").should route_to("contact_forms#create")
    end

    it "routes to #update" do
      put("/contact_forms/1").should route_to("contact_forms#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/contact_forms/1").should route_to("contact_forms#destroy", :id => "1")
    end

  end
end
