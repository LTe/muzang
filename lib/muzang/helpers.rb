module Muzang
  module Plugin
    module Helpers
      DEFAULT_MATCH_OPTIONS = { position: 1 }

      def on_channel?(message)
        message.channel
      end

      def match?(message, options = {})
        options = DEFAULT_MATCH_OPTIONS.merge(options)
        message.message.match(options[:regexp]) ? message.message.match(options[:regexp])[options[:position]] : false
      end

      def on_join?(connection, message)
        message.command == :join && message.nick == connection.nick
      end

      def create_database(file, container, variable)
        unless File.exist?(@config = ENV["HOME"] + "/.muzang")
          FileUtils.mkdir @config
        end

        unless File.exist? @config + "/#{file}"
          db = YAML.dump container
          File.open(@config + "/#{file}", "w"){|f| f.write(db)}
        end

        send(:"#{variable}=", YAML.load(File.open(@config + "/#{file}", "r").read))

        unless self.respond_to?(:save)
          self.class.send(:define_method, :save) do
            File.open(@config + "/#{file}", "w"){|f| f.write YAML.dump(send(variable))}
          end
        end
      end
    end
  end
end
