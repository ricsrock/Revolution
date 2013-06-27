require 'spec_helper'

describe "messages/edit" do
  before(:each) do
    @message = assign(:message, stub_model(Message,
      :to => "MyText",
      :from => 1,
      :body => "MyText"
    ))
  end

  it "renders the edit message form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", message_path(@message), "post" do
      assert_select "textarea#message_to[name=?]", "message[to]"
      assert_select "input#message_from[name=?]", "message[from]"
      assert_select "textarea#message_body[name=?]", "message[body]"
    end
  end
end
