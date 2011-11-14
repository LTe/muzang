require File.expand_path("../../../muzang/spec/spec_helper", __FILE__)
require 'muzang-eval'

describe "Eval" do
  before(:each) do
    @bot = stub
    @eval = Eval.new(@bot)
    @connection = ConnectionMock.new
    @message = OpenStruct.new({ :channel => "#test", :message => "% 1 + 1", :nick => "LTe" })
  end

  it "should eval ruby code" do
    @message.message = "% 1 + 1"
    EM.run do
      @eval.call(@connection, @message)
      eventually(true) { @connection.messages.include? "2" }
    end
  end

  it "@codegram should give me a t-shirt" do
    @message.message = "% \"@codegram\""
    EM.run do
      @eval.call(@connection, @message)
      eventually(true) { @connection.messages.include? "@codegram" }
    end
  end

  it "should not eval system method" do
    @message.message = "% system('rm -rf /')"
    EM.run do
      @eval.call(@connection, @message)
      eventually(true) { @connection.messages.include? "Error: Insecure operation - system" }
    end
  end

  it "should not crash after raise Exception" do
    @message.message = "% raise Exception"
    EM.run do
      @eval.call(@connection, @message)
      eventually(true) { @connection.messages.include? "Error: Exception" }
    end
  end
end
