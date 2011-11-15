require 'muzang'
require 'coffeemaker/bot'
require 'active_support/inflector/inflections'
require 'active_support/inflector/methods'

module Muzang
  class Bot
    attr_accessor :bot, :connection, :plugins, :channels

    def initialize(options = {})
      @options  = default_options.merge(options)
      @channels = @options.delete(:channels)
      @plugins  = {}
      @bot      = Coffeemaker::Bot.new(@options)

      @bot.irc.tap do |connection|
        connection.on_message = Proc.new do |m|
          @plugins.each do |plugin, instance|
            instance.call(connection, m) rescue nil
          end
        end
      end
    end

    def start
      @bot.start { |irc| @channels.each { |channel| irc.join(channel) } }
    end

    def register_plugin(plugin)
      klass = case plugin
      when Class
        plugin
      when String, Symbol
        klass_name = ActiveSupport::Inflector.classify(plugin.to_s)
        klass      = ActiveSupport::Inflector.constantize(klass_name)
      end
      @plugins[klass] = klass.new(self)
    end

    private
    def default_options
      {
        irc_host: 'localhost',
        irc_port: 6667,
        nick: 'DRUG-bot',
        channels: ['#test']
      }
    end
  end
end
