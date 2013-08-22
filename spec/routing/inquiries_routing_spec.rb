require "spec_helper"

describe InquiriesController do
  describe "routing" do

    it "routes to #index" do
      get("/inquiries").should route_to("inquiries#index")
    end

    it "routes to #new" do
      get("/inquiries/new").should route_to("inquiries#new")
    end

    it "routes to #show" do
      get("/inquiries/1").should route_to("inquiries#show", :id => "1")
    end

    it "routes to #edit" do
      get("/inquiries/1/edit").should route_to("inquiries#edit", :id => "1")
    end

    it "routes to #create" do
      post("/inquiries").should route_to("inquiries#create")
    end

    it "routes to #update" do
      put("/inquiries/1").should route_to("inquiries#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/inquiries/1").should route_to("inquiries#destroy", :id => "1")
    end

  end
end
