require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'drug-bot/plugins/reddit'

class Reddit
  def period
    1
  end
end

describe "Reddit" do
  include EM::SpecHelper

  before do
    @bot = stub
    @reddit = Reddit.new(@bot)
    @connection = stub(:msg => true, :options => { :nick => "DRUG-bot" })
    @message = { :command => "JOIN", :channel => "#test", :nick => "DRUG-bot" }
    @data = File.open(File.expand_path(File.dirname(__FILE__) + '/support/reddit.response'), "r").read
    EventMachine::MockHttpRequest.register('http://www.reddit.com/r/ruby/.rss', :get, {}, @data)
  end

  it "should call reddit and print all articles" do
    em do
      @reddit.last_update = Time.new 2010
      @connection.should_receive(:msg).exactly(25).times
      @reddit.call(@connection, @message)
      EM.add_timer(5){done}
    end
  end

  it "should print only one message" do
    em do
      @reddit.last_update = Time.new(2011, 9, 27, 21, 10, 0)
      @connection.should_receive(:msg).once
      @reddit.call(@connection, @message)
      EM.add_timer(5){done}
    end
  end

  it "should not print message" do
    em do
      @reddit.last_update = Time.now
      @connection.should_not_receive(:msg)
      @reddit.call(@connection, @message)
      EM.add_timer(5){done}
    end
  end
end
