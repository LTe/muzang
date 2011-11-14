require File.expand_path("../../../muzang/spec/spec_helper", __FILE__)
require 'muzang-meme'

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
    @message = OpenStruct.new({:channel => "#test", :message => "meme", :nick => "LTe" })
  end

  it "should print pretty help" do
    EM.run do
      @meme.call(@connection, @message)
      eventually(true) do
        @connection.messages.include?("Type 'meme [name of meme] \"Text0\" \"Text1\"'") and
        @connection.messages.include?("Available memes: #{Meme::MEMES.keys.join(" ")}")
      end
    end
  end

  it "should create meme and send message" do
    @message.message = "meme yuno \"hi0\" \"hi1\""
    EM.run do
      @meme.call(@connection, @message)
      eventually(1) { @connection.message_count }
      eventually(true) { @connection.messages.include? "Meme: http://version1.api.memegenerator.net//cache/instances/400x/10/10725/10982714.jpg" }
    end
  end

  it "should not create meme" do
    @message.message = "meme asdkasdj \"hi0\" \"hi1\""
    EM.run do
      @meme.call(@connection, @message)
      eventually(0) { @connection.message_count }
    end
  end
end
