$:.push File.expand_path("../../lib", __FILE__)

require 'drug-bot'

EM.run do
  @bot = DrugBot::Bot.new
  @bot.register_plugin(PlusOne)
  @bot.register_plugin(LiveReload)
  @bot.register_plugin(Motd)
  @bot.register_plugin(Reddit)
  @bot.register_plugin(Eval)
  @bot.register_plugin(NerdPursuit)
  @bot.start
end

