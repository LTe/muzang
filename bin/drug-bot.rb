$:.push File.expand_path("../../lib", __FILE__)

require 'drug-bot'
require 'yaml'

EM.run do
  @bot = DrugBot::Bot.new
  @bot.register_plugin(PlusOne)
  @bot.register_plugin(LiveReload)
  @bot.register_plugin(Motd)
  @bot.start
end

