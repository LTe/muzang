require 'rss/1.0'
require 'rss/2.0'
require 'eventmachine'

class Reddit
  def initialize(bot)
    @bot = bot

    unless File.exist?(@config = ENV["HOME"] + "/.drug-bot")
      FileUtils.mkdir @config
    end

    unless File.exist? @config + "/last_update.yml"
      db = YAML::dump Time.now
      File.open(@config + "/last_update.yml", "w"){|f| f.write(db)}
    end

    @last_update = YAML::load File.open(@config + "/last_update.yml", "r").read
  end

  def call(connection, message)
    if message[:command] == "JOIN" && message[:nick] == connection.options[:nick]
      EventMachine::add_periodic_timer(30) do
        @last_update = Time.now
        c_http = EM::Protocols::HttpClient2.connect 'www.reddit.com', 80
        http = c_http.get "/r/ruby/.rss"

        http.callback {|response|
          rss = RSS::Parser.parse(response.content, false)
          rss.items.each do |item|
            connection.msg(message[:channel], "#{item.title} | #{item.link}") if item.date > @last_update
          end
          save
        }
      end
    end
  end

  def save
    file = File.open(@config + "/last_update.yml", "w"){|f| f.write YAML::dump(@last_update)}
  end
end
