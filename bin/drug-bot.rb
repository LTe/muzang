$:.push File.expand_path("../../lib", __FILE__)

require 'drug-bot'

bot = Cinch::Bot.new do
  configure do |c|
    c.nick = "DRUG-bot"
    c.server = "irc.freenode.org"
    c.channels = ["#drug-bot"]
    c.plugins.plugins = [PlusOneStats]
  end
end

bot.start
