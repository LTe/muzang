require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Muzang" do
  before do
    @muzang = Muzang::Bot.new
    @muzang.bot.stub(:start) do
      Class.new{attr_accessor :on_message}.new
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
    @muzang.start
    @muzang.bot.irc.on_message.is_a?(Proc).should be_true
  end

  it "should execute call on plugin instance" do
    @muzang.register_plugin(DummyPlugin)
    @plugin_instance = @muzang.plugins[DummyPlugin]
    @plugin_instance.should_receive(:call).once
    @muzang.start
    @muzang.bot.irc.on_message.call
  end
end
