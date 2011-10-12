require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'drug-bot/plugins/nerdpursuit'
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
    @cq = JSON.parse(File.open("#{File.expand_path("../../lib/drug-bot/plugins/questions/ruby/matz.json", __FILE__)}").read)["question"]
    @nerdpursuit.current_question = @cq
  end

  it "should start quiz after !quiz message" do
    message = { :channel => "#test", :message => "!quiz", :nick => "LTe" }
    @nerdpursuit.call(@connection, message)
    @nerdpursuit.quiz_time.should == true
  end

  it "should parse question and start quiz sequence" do
    EM.run do
      message = { :channel => "#test", :message => "!quiz", :nick => "LTe" }
      @nerdpursuit.call(@connection, message)
      eventually(true, :every => 1, :total => 100) do
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
      message = { :channel => "#test", :message => "!quiz", :nick => "LTe" }
      message_lte = message.merge(:message => "3")
      @nerdpursuit.call(@connection, message)
      @nerdpursuit.call(@connection, message_lte)

      eventually(true, :every => 1, :total => 100) do
        @connection.messages.include? "The winner is... LTe" and
        @connection.messages.include? "Right answer: 3"
      end
    end
  end

  it "should not allow for many answers" do
    EM.run do
      message = { :channel => "#test", :message => "!quiz", :nick => "LTe" }
      @nerdpursuit.call(@connection, message)
      [1,2,3,4].each do |answer|
        @nerdpursuit.call(@connection, message.merge(:message => answer.to_s))
      end
        @nerdpursuit.call(@connection, message.merge(:message => "3", :nick => "PawelPacana"))

      eventually(true, :every => 1, :total => 100) do
        @connection.messages.include? "Right answer: 3"               and
        @connection.messages.include? "The winner is... PawelPacana"  and
        !@connection.messages.include? "The winner is... LTe"
      end
    end
  end
end
