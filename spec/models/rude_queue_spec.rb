require File.dirname(__FILE__) + '/../spec_helper'

describe RudeQueue do
  before(:each) do
    @rude_queue = RudeQueue.new
  end

  it "should be valid" do
    @rude_queue.should be_valid
  end
  
  describe "get and set" do
    it "should work with strings" do
      RudeQueue.set('abcde', "Something to set")
      RudeQueue.get('abcde').should == "Something to set"
    end
    it "should work with symbols" do
      RudeQueue.set('abcde', :a_symbol)
      RudeQueue.get('abcde').should == :a_symbol
    end
    it "should work with arrays" do
      array = [1, :b, "C"]
      RudeQueue.set('abcde', array)
      RudeQueue.get('abcde').should == array
    end
    it "should work with hashes" do
      hash = {:symbol => "A string", "stringy" => 23, 74 => :cheese}
      RudeQueue.set('abcde', hash)
      RudeQueue.get('abcde').should == hash
    end
    
    it "should :get in the same order they are :set" do
      RudeQueue.set('abcde', :first)
      RudeQueue.set('abcde', "second")
      
      RudeQueue.get('abcde').should == :first
      
      RudeQueue.set('abcde', 33.3333)
      
      RudeQueue.get('abcde').should == "second"
      RudeQueue.get('abcde').should == 33.3333
      RudeQueue.get('abcde').should be(nil)
    end
    
    it "should keep queues seperated" do
      RudeQueue.set('queue_1', :data_1)
      RudeQueue.set('queue_2', "DATA2")
      
      RudeQueue.get('queue_2').should == "DATA2"
      RudeQueue.get('queue_2').should be(nil)
      RudeQueue.get('queue_1').should == :data_1
      RudeQueue.get('queue_1').should be(nil)
    end
    
    it "should work with queue name as strings or symbols" do
      RudeQueue.set(:bah, "something about bah")
      RudeQueue.get("bah").should == "something about bah"
      
      RudeQueue.set("girah", {:craziness => "embodied"})
      RudeQueue.get(:girah).should == {:craziness => "embodied"}
    end
    
    it "should work with queue name as strings or integers" do
      RudeQueue.set(23, "something about bah")
      RudeQueue.get("23").should == "something about bah"
      
      RudeQueue.set("34", {:craziness => "embodied"})
      RudeQueue.get(34).should == {:craziness => "embodied"}
    end
  end
end