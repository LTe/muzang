require "drug-bot-motd/version"

class Motd
  include DrugBot::Plugin::Helpers

  def initialize(bot)
    @bot = bot
  end

  def call(connection, message)
    if on_join?(connection, message)
      connection.msg(message[:channel], "DRUG-bot | Version: #{DrugBot::VERSION} | Plugins: #{plugins}")
    end
  end

  def plugins
    list = ""
    @bot.plugins.each{|plugin, instance| list << "*#{plugin}* "}
    list
  end
end
