require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'drug-bot/plugins/livereload'

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
    path = File.expand_path("../../", __FILE__) + "/lib/drug-bot/plugins/livereload.rb"
    Kernel.should_receive(:load).with(path)
    @livereload.call(@connection, message)
  end

  it "should create new instance of plugin" do
    message = {:channel => "#test", :message => "!reload"}
    LiveReload.should_receive(:new).with(@bot)
    @livereload.call(@connection, message)
  end
end
