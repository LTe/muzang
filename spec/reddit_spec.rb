require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'drug-bot/plugins/reddit'

class Reddit
  def period
    1
  end
end

describe "Reddit" do
  before do
    @bot = stub
    @reddit = Reddit.new(@bot)
    @connection = ConnectionMock.new(:options => { :nick => "DRUG-bot" })
    @message = { :command => "JOIN", :channel => "#test", :nick => "DRUG-bot" }
    @file = File.expand_path('../support/reddit.response', __FILE__)
    EventMachine::MockHttpRequest.pass_through_requests = false
    EventMachine::MockHttpRequest.register_file('http://www.reddit.com:80/r/ruby/.rss', :get, @file)
    EventMachine::MockHttpRequest.activate!
  end

  it "should call reddit and print all articles" do
    @reddit.last_update = Time.new 2010
    EM.run do
      @reddit.call(@connection, @message)
      eventually(25, :every => 0.1, :total => 100) { @connection.message_count }
    end
  end

  it "should print only one message" do
    @reddit.last_update = Time.new(2011, 9, 29, 0, 47, 0)
    EM.run do
      @reddit.call(@connection, @message)
      eventually(1, :every => 0.1, :total => 100) { @connection.message_count }
    end
  end

  it "should not print message" do
    @reddit.last_update = Time.now
    EM.run do
      @reddit.call(@connection, @message)
      eventually(0, :every => 0.1, :total => 100) { @connection.message_count }
    end
  end
end
