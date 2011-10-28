module DrugBot
  class Bot
    attr_accessor :bot, :connection, :plugins, :engine, :channel

    def initialize(options = {})
      @channel = options[:channel] || "#test"
      @plugins = {}
      callback =  Proc.new do |m|
          @plugins.each do |plugin, instance|
            puts m.inspect
            begin
              instance.call(@connection, m)
            rescue Exception => e
              # place for exceptioner?;-)
            end
          end
        end

      @bot = Coffeemaker::Bot.new(:irc_host   => options[:host]     || "localhost" ,
                                  :irc_port   => options[:port]     || 6667,
                                  :on_message => callback,
                                  :nick       => options[:nick]     || "DRUG-bot")
    end

    def start
      @bot.start do |irc|
        irc.join(@channel)
      end
    end

    def register_plugin(plugin)
      @plugins[plugin] = plugin.new(self)
    end
  end
end
