require 'eventmachine'
require 'logger'

module Coffeemaker
  class IRC
    class Error < StandardError; end

    class Message
      attr_accessor :raw, :prefix, :command, :params

      def initialize(msg = nil)
        @raw = msg
        parse if msg
      end

      def numeric_reply?
        !!numeric_reply
      end

      def numeric_reply
        @numeric_reply ||= @command.match(/^\d\d\d$/)
      end

      def parse
        match = @raw.match(/(^:(\S+) )?(\S+)(.*)/)
        _, @prefix, @command, raw_params = match.captures

        raw_params.strip!
        if match = raw_params.match(/:(.*)/)
          @params = match.pre_match.split(" ")
          @params << match[1]
        else
          @params = raw_params.split(" ")
        end
      end

      def nick
        return unless @prefix
        @nick ||= @prefix[/^(\S+)!/, 1]
      end

      def user
        return unless @prefix
        @user ||= @prefix[/^\S+!(\S+)@/, 1]
      end

      def host
        return unless @prefix
        @host ||= @prefix[/@(\S+)$/, 1]
      end

      def server
        return unless @prefix
        return if @prefix.match(/[@!]/)
        @server ||= @prefix[/^(\S+)/, 1]
      end

      def error?
        !!error
      end

      def error
        return @error if @error
        @error = command.to_i if numeric_reply? && command[/[45]\d\d/]
      end

      def channel?
        !!channel
      end

      def channel
        return @channel if @channel
        if regular_command? and params.first.start_with?("#")
          @channel = params.first
        end
      end

      def message
        return @message if @message
        if error?
          @message = error.to_s
        elsif regular_command?
          @message = params.last
        end
      end

      def to_param
        {
          :command => command,
          :user    => user,
          :nick    => nick,
          :host    => host,
          :message => message,
          :channel => channel
        }
      end

      private
      def regular_command?
        %w(PRIVMSG JOIN PART QUIT).include? command
      end
    end

    class Dispatcher
      def parse(line)
        Message.new('UNKNOWN', line)
      end
    end

    module Commands
      def join(channel)
        command("JOIN ##{channel}")
      end

      def part(channel)
        command("PART ##{channel}")
      end

      def msg(recipient, text)
        command("PRIVMSG #{recipient} :#{text}")
      end
    end

    module Connection
      include EM::Deferrable
      include EM::Protocols::LineText2
      include Commands

      attr_accessor :port, :host, :options, :on_message

      def connection_completed
        @reconnecting = false
        @connected    = true
        succeed
        command('USER', [options[:nick]] * 4)
        command('NICK', options[:nick])
        join(options[:channel])
      end

      def receive_line(data)
        msg = Message.new(data)
        case msg.command
        when 'PING'
          command('PONG')
        when 'PRIVMSG', 'TOPIC', 'PART', 'JOIN'
          on_message.call(msg.to_param) if on_message
        end
      end

      def unbind
        @deferred_status = nil
        if @connected or @reconnecting
          EM.add_timer(1) do
            reconnect(@host, @port)
          end
          @connected    = false
          @reconnecting = true
        else
          raise Error, "unable to connect to server (#{@host}, #{@port})"
        end
      end

      private
      def command(*cmd)
        send_data("#{cmd.flatten.join(' ')}\r\n")
      end
    end

    def initialize(options)
      @host    = options.delete(:irc_host)
      @port    = options.delete(:irc_port)
      @options = options
    end

    def start
      @connection = EM.connect(@host, @port, Connection) do |c|
        c.host    = @host
        c.port    = @port
        c.options = @options
      end
    end

    def stop
      @connection.close_connection
    end
  end
end
