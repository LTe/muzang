require File.expand_path("../../../muzang/spec/spec_helper", __FILE__)
require 'muzang-motd'

describe "Motd" do
  before do
    @message = OpenStruct.new({ :command => :join, :channel => "#test", :nick => "DRUG-bot" })
    @bot = stub
    @motd = Motd.new(@bot)
    @bot.stub(:plugins => { Motd => @motd })
    @connection = stub(:msg => true, :nick => "DRUG-bot")
  end

  it "should send message after join to channel" do
    @connection.should_receive(:msg).with("#test", "DRUG-bot | Version: #{Muzang::VERSION} | Plugins: *Motd* ")
    @motd.call(@connection, @message)
  end
end

