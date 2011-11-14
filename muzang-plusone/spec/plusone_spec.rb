require File.expand_path("../../../muzang/spec/spec_helper", __FILE__)
require 'muzang-plusone'

describe "PlusOne" do
  before(:each) do
    @bot = stub
    @plusone = PlusOne.new(@bot)
    @plusone.stats = { "LTe" => 1, "ruby" => 1 }
    @connection = stub(:msg => true)
    @message = OpenStruct.new({ :channel => "#test", :message => "LTe: +1 for great irc bot", :nick => "LTe"})
  end

  it "should not add plus one for myself" do
    @connection.should_receive(:msg).with("#test", "LTe pisze w PHP")
    @plusone.call(@connection, @message)
    @plusone.stats["LTe"].should == 1
  end

  it "should not allow to add plus one for new user" do
    @message.nick = "new_user"
    @connection.should_receive(:msg).with("#test", "new_user pisze w PHP")
    @plusone.call(@connection, @message)
    @plusone.stats["LTe"].should == 1
  end

  it "should print stats" do
    @message.message = "!stats"; @message.nick = "LTe"
    @connection.should_receive(:msg).once
    @plusone.call(@connection, @message)
  end

  [
    "LTe: +1 for great irc bot",
    "LTe +1 for grat bot",
    "LTe +1"
  ].each do |m|
    it "should react on message #{m}" do
      proper_plus_one(m)
    end
  end

  [
    "LTe:  +1",
    "LTe: plus (+1) feature is great",
    "I think +1 is great",
    "LTe: great +1"
  ].each do |m|
    it "should not react on message #{m}" do
      invalid_plus_one(m)
    end
  end

end

def invalid_plus_one(message)
  @message = OpenStruct.new({ :channel => "#test", :message => message, :nick => "ruby" })
  @connection.should_not_receive(:msg).with("#test", "ruby podarowal +1 dla *LTe*")
  @plusone.call(@connection, @message)
  @plusone.stats["LTe"].should == 1
end

def proper_plus_one(message)
  @message = OpenStruct.new({ :channel => "#test", :message => message, :nick => "ruby" })
  @connection.should_receive(:msg).with("#test", "ruby podarowal +1 dla *LTe*")
  @plusone.call(@connection, @message)
  @plusone.stats["LTe"].should == 2
end
