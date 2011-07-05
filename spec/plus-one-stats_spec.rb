require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'drug-bot/plus-one-stats'

describe PlusOneStats do

  include MockBot

  before(:each) do
    @bot = mock_bot do
      configure do |c|
        c.nick = "DRUG-bot"
        c.verbose = true
        c.channels = ["#drug-bot"]
        c.server = "localhost"
        c.plugins.plugins = [PlusOneStats]
      end
    end

    @bot_thread = Thread.start{@bot.start}
    bot_is_connected
    join_to_channel('drug-bot')
  end

  it "print notice after plus one on channel" do
    @bot.plugins.first.should_receive(:plus_one)
    send_message('LTe', '#drug-bot', "mlomnicki: +1")
    sleep 0.5
  end

  it "should not print notice on channel" do
    @bot.plugins.first.should_receive(:plus_one).exactly(0).times
    send_message('LTe', '#drug-bot', "mlomnicki: _+1")
    sleep 0.5
  end

end
