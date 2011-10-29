require 'drug-bot'
require 'coffeemaker/bot'
require 'active_support/inflector'

module DrugBot
  class Bot
    attr_accessor :bot, :connection, :plugins, :channel

    def initialize(options = {})
      @options = default_options.merge(options)
      @channel = @options.delete(:channel)
      @plugins = {}
      @bot     = Coffeemaker::Bot.new(@options)

      @bot.irc.tap do |connection|
        connection.on_message = Proc.new do |m|
          @plugins.each do |plugin, instance|
            instance.call(connection, m) rescue nil
          end
        end
      end
    end

    def start
      @bot.start { |irc| irc.join(@channel) }
    end

    def register_plugin(plugin)
      klass = case plugin
      when Class
        plugin
      when String, Symbol
        plugin.to_s.classify.constantize
      end
      @plugins[klass] = klass.new(self)
    end

    private
    def default_options
      {
        irc_host: 'localhost',
        irc_port: 6667,
        nick: 'DRUG-bot',
        channel: '#test'
      }
    end
  end
end
