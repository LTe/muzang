$:.push File.expand_path("../../lib", __FILE__)

require 'drug-bot'
require 'drug-bot/plugins/plusone'
require 'drug-bot/plugins/livereload'
require 'drug-bot/plugins/motd'
require 'drug-bot/plugins/rubygems'
require 'drug-bot/plugins/reddit'
require 'drug-bot/plugins/eval'

EM.run do
  @bot = DrugBot::Bot.new
  @bot.register_plugin(PlusOne)
  @bot.register_plugin(LiveReload)
  @bot.register_plugin(Motd)
  #@bot.register_plugin(RubyGems)
  @bot.register_plugin(Reddit)
  @bot.register_plugin(Eval)
  @bot.start
end

