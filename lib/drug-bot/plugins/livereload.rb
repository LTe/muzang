class LiveReload
  def initialize(bot)
    @bot = bot
  end

  def call(connection, message)
    if message[:channel]
      if message[:message].match(/^!reload$/) && message[:message].match(/^!reload$/)[0]
        plugins_path = File.expand_path("../", __FILE__) + "/"
        @bot.plugins.each do |plugin, instance|
          load(plugins_path + plugin.to_s.downcase + ".rb")
          instance = plugin.new(@bot)
          connection.msg(message[:channel], "Reloading: #{plugin}")
        end
      end
    end
  end
end
