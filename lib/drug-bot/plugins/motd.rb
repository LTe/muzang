class Motd
  def initialize(bot)
    @bot = bot
  end

  def call(connection, message)
    if message[:command] == "JOIN" && message[:nick] == connection.options[:nick]
      connection.msg(message[:channel], "DRUG-bot | Version: #{DrugBot::VERSION} | Plugins: #{plugins}")
    end
  end

  def plugins
    list = ""
    @bot.plugins.each{|plugin, instance| list << "*#{plugin}* "}
    list
  end
end
