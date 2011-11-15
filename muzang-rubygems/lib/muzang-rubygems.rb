require "em-http-request"
require "json"

class RubyGems
  include Muzang::Plugin::Helpers

  attr_accessor :last_gem

  def initialize(bot)
    @bot = bot
    create_database("last_gem.yml", String.new, :last_gem)
  end

  def call(connection, message)
    if on_join?(connection, message)
      EventMachine.add_periodic_timer(period) do
        http = EventMachine::HttpRequest.new('http://rubygems.org/api/v1/gems/latest.json').get

        http.errback {
          # exceptioner
        }

        http.callback {
          gems = JSON.parse(http.response)
          gem = gems.first
          unless @last_gem == gem["name"]
            @last_gem = gem["name"]
            connection.msg(message.channel, "Nowy gem! | #{gem["name"]} | #{gem["info"]} | #{gem["project_uri"]}")
            save
          end
        }
      end
    end
  end

  def save
    file = File.open(@config + "/last_gem.yml", "w"){|f| f.write YAML::dump(@last_gem)}
  end

  def period
    30
  end
end
