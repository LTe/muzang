module DrugBot
  class Bot
    attr_accessor :bot, :connection, :plugins

    def initialize(options = {})
	    @bot = Coffeemaker::IRC.new(:irc_host => options[:host]     || "localhost" ,
                                  :irc_port => options[:port]     || 6667,
                                  :nick     => options[:nick]     || "DRUG-bot",
                                  :channel  => options[:channel]  || "test")

      @plugins = {}
    end

    def start
      @connection = @bot.start
      @connection.on_message = Proc.new do |m|
        @plugins.each do |plugin, instance|
          begin
            instance.call(@connection, m)
          rescue Exception => e
            # place for exceptioner?;-)
          end
        end
      end
    end

    def register_plugin(plugin)
      @plugins[plugin] = plugin.new(self)
    end


  end
end
