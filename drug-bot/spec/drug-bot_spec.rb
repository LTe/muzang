require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "DrugBot" do
  before do
    @bot = DrugBot::Bot.new
    @bot.bot.stub(:start) do
      Class.new{attr_accessor :on_message}.new
    end
  end

  it "should have empty plugins map" do
    @bot = DrugBot::Bot.new
    @bot.plugins.should == {}
  end

  it "should register plugin" do
    @bot.register_plugin(DummyPlugin)
    @bot.plugins.has_key?(DummyPlugin).should be_true
    @bot.plugins[DummyPlugin].is_a?(DummyPlugin).should be_true
  end

  it "should create plugins proc" do
    @bot.start
    @bot.connection.on_message.is_a?(Proc).should be_true
  end

  it "should execute call on plugin instance" do
    @bot.register_plugin(DummyPlugin)
    @plugin_instance = @bot.plugins[DummyPlugin]
    @plugin_instance.should_receive(:call).once
    @bot.start
    @bot.connection.on_message.call
  end
end
