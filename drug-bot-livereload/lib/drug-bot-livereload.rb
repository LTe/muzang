require "drug-bot-livereload/version"

class LiveReload
  include DrugBot::Plugin::Helpers

  def initialize(bot)
    @bot = bot
  end

  def call(connection, message)
    if on_channel?(message)
      if match?(message, :regexp => /^!reload$/, :position => 0)
        plugins_path = File.expand_path("../", __FILE__) + "/"
        @bot.plugins.each do |plugin, instance|
          Kernel.load(plugins_path + plugin.to_s.downcase + ".rb")
          instance = plugin.new(@bot)
          connection.msg(message[:channel], "Reloading: #{plugin}")
        end
      end
    end
  end
end
