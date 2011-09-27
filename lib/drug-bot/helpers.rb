module DrugBot
  module Plugin
    module Helpers
      def on_channel?(message)
        message[:channel]
      end

      def match?(message, regexp)
        message[:message].match(regexp) ? message[:message].match(regexp)[1] : false
      end

      def on_join?(connection, message)
        message[:command] == "JOIN" && message[:nick] == connection.options[:nick]
      end

      def create_database(file, container, variable)
        unless File.exist?(@config = ENV["HOME"] + "/.drug-bot")
          FileUtils.mkdir @config
        end

        unless File.exist? @config + "/#{file}"
          db = YAML::dump container
          File.open(@config + "/#{file}", "w"){|f| f.write(db)}
        end

        send(:"#{variable}=", YAML::load(File.open(@config + "/#{file}", "r").read))

        Object.send(:define_method, :save) do
          file = File.open(@config + "/#{file}", "w"){|f| f.write YAML::dump(send(variable))}
        end
      end
    end
  end
end
