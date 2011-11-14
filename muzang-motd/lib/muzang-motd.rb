class Motd
  include Muzang::Plugin::Helpers

  def initialize(bot)
    @bot = bot
  end

  def call(connection, message)
    if on_join?(connection, message)
      connection.msg(message.channel, "DRUG-bot | Version: #{Muzang::VERSION} | Plugins: #{plugins}")
    end
  end

  def plugins
    list = ""
    @bot.plugins.each{|plugin, instance| list << "*#{plugin}* "}
    list
  end
end
