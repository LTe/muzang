$:.push File.expand_path("../../drug-bot/lib", __FILE__)
require 'drug-bot'

EM.run do
  bot = DrugBot::Bot.new

  %w(plus_one live_reload motd reddit eval nerd_pursuit).each do |plugin|
    dirname = "drug-bot-#{plugin.gsub(/_/, '')}"
    $:.push File.expand_path("../../#{dirname}/lib", __FILE__)

    require "#{dirname}"
    bot.register_plugin(plugin)
  end
  bot.start
end
