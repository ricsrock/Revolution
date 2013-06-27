require "spec_helper"

describe MeetingTimesController do
  describe "routing" do

    it "routes to #index" do
      get("/meeting_times").should route_to("meeting_times#index")
    end

    it "routes to #new" do
      get("/meeting_times/new").should route_to("meeting_times#new")
    end

    it "routes to #show" do
      get("/meeting_times/1").should route_to("meeting_times#show", :id => "1")
    end

    it "routes to #edit" do
      get("/meeting_times/1/edit").should route_to("meeting_times#edit", :id => "1")
    end

    it "routes to #create" do
      post("/meeting_times").should route_to("meeting_times#create")
    end

    it "routes to #update" do
      put("/meeting_times/1").should route_to("meeting_times#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/meeting_times/1").should route_to("meeting_times#destroy", :id => "1")
    end

  end
end
