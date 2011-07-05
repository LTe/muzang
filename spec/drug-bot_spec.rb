require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "DrugBot" do

  include MockBot

  before(:each) do
    @bot = mock_bot do
      configure do |c|
        c.nick = "DRUG-bot"
        c.verbose = false
        c.channels = ["#drug-bot"]
        c.server = "localhost"
      end
    end

    @bot_thread = Thread.start{@bot.start}
  end

  it "bot should connect to server and join channel" do
    bot_is_connected
    join_to_channel("drug-bot")
  end
end
