require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'drug-bot/plugins/motd'

describe "Motd" do
  before do
    @message = { :command => "JOIN", :channel => "#test" }
    @bot = stub
    @motd = Motd.new(@bot)
    @bot.stub(:plugins => { Motd => @motd })
    @connection = stub(:msg => true)
  end

  it "should send message after join to channel" do
    @connection.should_receive(:msg).with("#test", "DRUG-bot | Version: #{DrugBot::VERSION} | Plugins: *Motd* ")
    @motd.call(@connection, @message)
  end
end
