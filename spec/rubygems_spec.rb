require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'drug-bot/plugins/rubygems'

class RubyGems
  def period
    1
  end
end

describe "RubyGems" do
  include EM::SpecHelper

  before do
    @bot = stub
    @rubygems = RubyGems.new(@bot)
    @connection = stub(:msg => true, :options => { :nick => "DRUG-bot" })
    @message = { :command => "JOIN", :channel => "#test", :nick => "DRUG-bot" }
    @data = File.open(File.expand_path(File.dirname(__FILE__) + '/support/rubygems.response'), "r").read
    EventMachine::MockHttpRequest.register('http://rubygems.org/api/v1/gems/latest.json', :get, {}, @data)
  end

  it "should print last gem" do
    em do
      @connection.should_receive(:msg).once
      @rubygems.last_gem = "fake_gem"
      @rubygems.call(@connection, @message)
      EM.add_timer(10){done}
    end
  end

  it "should not print the same gem" do
    @connection.should_receive(:msg)

    em do
      @rubygems.last_gem = "action_links"
      @rubygems.call(@connection, @message)
      EM.add_timer(5){done}
    end
  end
end
