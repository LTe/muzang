$:.push File.expand_path("../../muzang/lib", __FILE__)
require 'muzang'

EM.run do
  bot = Muzang::Bot.new

  %w(plus_one live_reload motd reddit eval nerd_pursuit).each do |plugin|
    dirname = "muzang-#{plugin.gsub(/_/, '')}"
    $:.push File.expand_path("../../#{dirname}/lib", __FILE__)

    require "#{dirname}"
    bot.register_plugin(plugin)
  end
  bot.start
end
