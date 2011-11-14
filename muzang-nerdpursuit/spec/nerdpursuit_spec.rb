require File.expand_path("../../../muzang/spec/spec_helper", __FILE__)
require 'muzang-nerdpursuit'
require 'json'

class NerdPursuit
  def current_question=(other)
    @current_question=other
  end

  def period(time)
    time / 1000.0
  end
end

describe "NerdPursuit" do
  before(:each) do
    @bot = stub
    @nerdpursuit = NerdPursuit.new(@bot)
    @connection = ConnectionMock.new
    @cq = JSON.parse(File.open("#{File.expand_path("../../lib/muzang-nerdpursuit/questions/ruby/matz.json", __FILE__)}").read)["question"]
    @nerdpursuit.current_question = @cq
    @message = OpenStruct.new({ :channel => "#test", :message => "!quiz", :nick => "LTe" })
  end

  it "should start quiz after !quiz message" do
    @nerdpursuit.call(@connection, @message)
    @nerdpursuit.quiz_time.should == true
  end

  it "should parse question and start quiz sequence" do
    EM.run do
      @nerdpursuit.call(@connection, @message)
      eventually(true) do
        @connection.messages.include? "Quiz time!"                          and
        @connection.messages.include? "Category: ruby"                      and
        @connection.messages.include? "Question: When Matz joined Heruku?"  and
        @connection.messages.include? "Answer 1: 12th June 2008"            and
        @connection.messages.include? "Answer 2: 12th July 2011"            and
        @connection.messages.include? "Answer 3: 12th June 2011"            and
        @connection.messages.include? "Answer 4: 12th June 2010"
      end
    end
  end

  it "should find winner" do
    EM.run do
      @message_lte = @message.dup
      @message_lte.message = "3"
      @nerdpursuit.call(@connection, @message)
      @nerdpursuit.call(@connection, @message_lte)

      eventually(true) do
        @connection.messages.include? "The winner is... LTe" and
        @connection.messages.include? "Right answer: 3"
      end
    end
  end

  it "should not allow for many answers" do
    EM.run do
      @nerdpursuit.call(@connection, @message)
      [1,2,3,4].each do |answer|
        @message.message = answer.to_s
        @nerdpursuit.call(@connection, @message)
      end
        @message.message = "3"; @message.nick = "PawelPacana"
        @nerdpursuit.call(@connection, @message)

      eventually(true) do
        @connection.messages.include? "Right answer: 3"               and
        @connection.messages.include? "The winner is... PawelPacana"  and
        !@connection.messages.include? "The winner is... LTe"
      end
    end
  end
end
