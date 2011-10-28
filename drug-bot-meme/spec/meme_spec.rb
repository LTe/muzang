require File.expand_path("../../../drug-bot/spec/spec_helper", __FILE__)
require 'drug-bot-meme'

describe "Meme" do
  before do
    @bot = stub(:channel => "test")
    @meme = Meme.new(@bot)
    @connection = ConnectionMock.new
    @url = "http://version1.api.memegenerator.net:80/Instance_Create?username=drug-bot&password=drug-bot&languageCode=en&generatorID=2&imageID=166088&text0=hi0&text1=hi1"
    @file = File.expand_path("../meme.response", __FILE__)
    EventMachine::MockHttpRequest.pass_through_requests = false
    EventMachine::MockHttpRequest.register_file(@url, :get, @file)
    EventMachine::MockHttpRequest.activate!
  end

  it "should print pretty help" do
    EM.run do
      message = { :channel => "#test", :message => "meme", :nick => "LTe" }
      @meme.call(@connection, message)
      eventually(true, :every => 0.1, :total => 100) do
        @connection.messages.include?("Type 'meme [name of meme] \"Text0\" \"Text1\"'") and
        @connection.messages.include?("Available memes: #{Meme::MEMES.keys.join(" ")}")
      end
    end
  end

  it "should create meme and send message" do
    message = { :channel => "#test", :message => "meme yuno \"hi0\" \"hi1\"", :nick => "LTe" }
    EM.run do
      @meme.call(@connection, message)
      eventually(1, :every => 0.1, :total => 100) { @connection.messages.count }
      eventually(true, :every => 0.1, :total => 100) { @connection.messages.include? "Meme: http://version1.api.memegenerator.net//cache/instances/400x/10/10725/10982714.jpg" }
    end
  end

  it "should not create meme" do
    message = { :channel => "#test", :message => "meme asdkasdj \"hi0\" \"hi1\"", :nick => "LTe" }
    EM.run do
      @meme.call(@connection, message)
      eventually(0, :every => 0.1, :total => 100) { @connection.message_count }
    end
  end
end