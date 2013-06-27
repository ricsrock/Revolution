require "spec_helper"

describe EnrollmentsController do
  describe "routing" do

    it "routes to #index" do
      get("/enrollments").should route_to("enrollments#index")
    end

    it "routes to #new" do
      get("/enrollments/new").should route_to("enrollments#new")
    end

    it "routes to #show" do
      get("/enrollments/1").should route_to("enrollments#show", :id => "1")
    end

    it "routes to #edit" do
      get("/enrollments/1/edit").should route_to("enrollments#edit", :id => "1")
    end

    it "routes to #create" do
      post("/enrollments").should route_to("enrollments#create")
    end

    it "routes to #update" do
      put("/enrollments/1").should route_to("enrollments#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/enrollments/1").should route_to("enrollments#destroy", :id => "1")
    end

  end
end
