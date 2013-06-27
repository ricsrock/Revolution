require "spec_helper"

describe MyColorsController do
  describe "routing" do

    it "routes to #index" do
      get("/my_colors").should route_to("my_colors#index")
    end

    it "routes to #new" do
      get("/my_colors/new").should route_to("my_colors#new")
    end

    it "routes to #show" do
      get("/my_colors/1").should route_to("my_colors#show", :id => "1")
    end

    it "routes to #edit" do
      get("/my_colors/1/edit").should route_to("my_colors#edit", :id => "1")
    end

    it "routes to #create" do
      post("/my_colors").should route_to("my_colors#create")
    end

    it "routes to #update" do
      put("/my_colors/1").should route_to("my_colors#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/my_colors/1").should route_to("my_colors#destroy", :id => "1")
    end

  end
end
