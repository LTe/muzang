$:.push File.expand_path("../../lib", __FILE__)

require 'drug-bot'
require 'drug-bot/plugins/plusone'
require 'drug-bot/plugins/livereload'
require 'drug-bot/plugins/motd'

EM.run do
  @bot = DrugBot::Bot.new
  @bot.register_plugin(PlusOne)
  @bot.register_plugin(LiveReload)
  @bot.register_plugin(Motd)
  @bot.start
end

