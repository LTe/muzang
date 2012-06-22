require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Muzang" do
  before do
    @muzang = Muzang::Bot.new
    @muzang.bot.stub(:start) do
      @connection = Class.new { include Coffeemaker::Bot::Irc::Connection }.new
      @connection.on_connect = @muzang.bot.irc.on_connect
      @connection.on_message = @muzang.bot.irc.on_message
      @connection.stub(:send_data)
      @connection
    end
  end

  it "should have empty plugins map" do
    @muzang = Muzang::Bot.new
    @muzang.plugins.should == {}
  end

  it "should register plugin" do
    @muzang.register_plugin(DummyPlugin)
    @muzang.plugins.has_key?(DummyPlugin).should be_true
    @muzang.plugins[DummyPlugin].is_a?(DummyPlugin).should be_true
  end

  it "should create plugins proc" do
    @muzang.bot.irc.on_message.is_a?(Proc).should be_true
  end

  it "should create hook for joining to the channels" do
    @muzang.bot.irc.on_connect.is_a?(Proc).should be_true
  end

  it "should join to channels" do
    @muzang.bot.irc.on_connect.should_receive(:call).once
    connection = @muzang.start
    connection.connection_completed
  end

  it "should execute call on plugin instance" do
    @muzang.register_plugin(DummyPlugin)
    @plugin_instance = @muzang.plugins[DummyPlugin]
    @plugin_instance.should_receive(:call).once
    connection = @muzang.start
    connection.receive_line(':CalebDelnay!calebd@localhost PRIVMSG #mychannel :Hello everyone!')
  end
end
