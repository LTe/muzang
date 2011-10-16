require File.expand_path("../../../drug-bot/spec/spec_helper", __FILE__)
require 'drug-bot-livereload'

describe "LiveReload" do
  before(:each) do
    @bot = stub
    @livereload = LiveReload.new(@bot)
    @bot.stub(:plugins => { LiveReload => @livereload })
    @connection = stub(:msg => true)
    Kernel.stub(:load)
  end

  it "should load plugins" do
    message = {:channel => "#test", :message => "!reload"}
    Kernel.should_receive(:load).with('drug-bot-livereload')
    @livereload.call(@connection, message)
  end

  it "should create new instance of plugin" do
    message = {:channel => "#test", :message => "!reload"}
    LiveReload.should_receive(:new).with(@bot)
    @livereload.call(@connection, message)
  end
end
