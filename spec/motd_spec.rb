require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Motd" do
  before do
    @message = { :command => "JOIN", :channel => "#test", :nick => "DRUG-bot" }
    @bot = stub
    @motd = Motd.new(@bot)
    @bot.stub(:plugins => { Motd => @motd })
    @connection = stub(:msg => true, :options => { :nick => "DRUG-bot" })
  end

  it "should send message after join to channel" do
    @connection.should_receive(:msg).with("#test", "DRUG-bot | Version: #{DrugBot::VERSION} | Plugins: *Motd* ")
    @motd.call(@connection, @message)
  end
end

