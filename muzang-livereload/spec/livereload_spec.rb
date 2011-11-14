require File.expand_path("../../../muzang/spec/spec_helper", __FILE__)
require 'muzang-livereload'

describe "LiveReload" do
  before(:each) do
    @bot = stub
    @livereload = LiveReload.new(@bot)
    @bot.stub(:plugins => { LiveReload => @livereload })
    @connection = stub(:msg => true)
    Kernel.stub(:load)
    @message = OpenStruct.new({:channel => "#test", :message => "!reload"})
  end

  it "should load plugins" do
    Kernel.should_receive(:load).with('muzang-livereload.rb')
    @livereload.call(@connection, @message)
  end

  it "should create new instance of plugin" do
    LiveReload.should_receive(:new).with(@bot)
    @livereload.call(@connection, @message)
  end
end
