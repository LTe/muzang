require File.expand_path("../../../drug-bot/spec/spec_helper", __FILE__)
require 'drug-bot-rubygems'

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
    @message = OpenStruct.new({ :command => "JOIN", :channel => "#test", :nick => "DRUG-bot" })
    @file = File.expand_path('../rubygems.response', __FILE__)
    EventMachine::MockHttpRequest.pass_through_requests = false
    EventMachine::MockHttpRequest.register_file('http://rubygems.org:80/api/v1/gems/latest.json', :get, @file)
    EventMachine::MockHttpRequest.activate!
  end

  it "should print last gem" do
    @rubygems.last_gem = "fake_gem"
    EM.run do
      @rubygems.call(@connection, @message)
      eventually(1) { @connection.message_count }
    end
  end

  it "should not print last gem" do
    @rubygems.last_gem = "action_links"
    EM.run do
      @rubygems.call(@connection, @message)
      eventually(0) { @connection.message_count }
    end
  end
end
