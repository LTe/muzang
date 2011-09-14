require 'rubygems'
require 'json'

class RubyGems
  def initialize(bot)
    @bot = bot

    unless File.exist?(@config = ENV["HOME"] + "/.drug-bot")
      FileUtils.mkdir @config
    end

    unless File.exist? @config + "/last_gem.yml"
      db = YAML::dump ""
      File.open(@config + "/last_gem.yml", "w"){|f| f.write(db)}
    end

    @last_gem = YAML::load File.open(@config + "/last_gem.yml", "r").read
  end

  def call(connection, message)
    if message[:command] == "JOIN" && message[:nick] == connection.options[:nick]
      EventMachine::add_periodic_timer(10) do
        c_http = EM::Protocols::HttpClient2.connect 'rubygems.org', 80
        http = c_http.get "/api/v1/gems/latest.json"

        http.callback {|response|
          gems = JSON.parse(response.content)
          gem = gems.first
          unless @last_gem == gem["name"]
            @last_gem = gem["name"]
            connection.msg(message[:channel], "Nowy gem! | #{gem["name"]} | #{gem["info"]} | #{gem["project_uri"]}")
            save
          end
        }
      end
    end
  end

  def save
    file = File.open(@config + "/last_gem.yml", "w"){|f| f.write YAML::dump(@last_gem)}
  end
end
