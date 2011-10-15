require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'drug-bot/plugins/eval'

describe "Eval" do
  before(:each) do
    @bot = stub
    @eval = Eval.new(@bot)
    @connection = ConnectionMock.new
  end

  it "should eval ruby code" do
    message = { :channel => "#test", :message => "% 1 + 1", :nick => "LTe" }
    EM.run do
      @eval.call(@connection, message)
      eventually(true) { @connection.messages.include? "2" }
    end
  end

  it "@codegram should give me a t-shirt" do
    message = { :channel => "#test", :message => "% \"@codegram\"", :nick => "LTe" }
    EM.run do
      @eval.call(@connection, message)
      eventually(true) { @connection.messages.include? "@codegram" }
    end
  end

  it "should not eval system method" do
    message = { :channel => "#test", :message => "% system('rm -rf /')", :nick => "LTe" }
    EM.run do
      @eval.call(@connection, message)
      eventually(true) { @connection.messages.include? "Error: Insecure operation - system" }
    end
  end

  it "should not crash after raise Exception" do
    message = { :channel => "#test", :message => "% raise Exception", :nick => "LTe" }
    EM.run do
      @eval.call(@connection, message)
      eventually(true) { @connection.messages.include? "Error: Exception" }
    end
  end
end
