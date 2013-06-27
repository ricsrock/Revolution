require 'spec_helper'

describe "messages/new" do
  before(:each) do
    assign(:message, stub_model(Message,
      :to => "MyText",
      :from => 1,
      :body => "MyText"
    ).as_new_record)
  end

  it "renders new message form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", messages_path, "post" do
      assert_select "textarea#message_to[name=?]", "message[to]"
      assert_select "input#message_from[name=?]", "message[from]"
      assert_select "textarea#message_body[name=?]", "message[body]"
    end
  end
end
