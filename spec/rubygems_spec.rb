require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class RubyGems
  def period
    1
  end
end

describe "RubyGems" do
  before do
    @bot = stub
    @rubygems = RubyGems.new(@bot)
    @connection = ConnectionMock.new(:options => { :nick => "DRUG-bot" })
    @message = { :command => "JOIN", :channel => "#test", :nick => "DRUG-bot" }
    @file = File.expand_path('../support/rubygems.response', __FILE__)
    EventMachine::MockHttpRequest.pass_through_requests = false
    EventMachine::MockHttpRequest.register_file('http://rubygems.org:80/api/v1/gems/latest.json', :get, @file)
    EventMachine::MockHttpRequest.activate!
  end

  it "should print last gem" do
    @rubygems.last_gem = "fake_gem"
    EM.run do
      @rubygems.call(@connection, @message)
      eventually(1, :every => 0.1, :total => 100) { @connection.message_count }
    end
  end

  it "should not print last gem" do
    @rubygems.last_gem = "action_links"
    EM.run do
      @rubygems.call(@connection, @message)
      eventually(0, :every => 0.1, :total => 100) { @connection.message_count }
    end
  end
end
