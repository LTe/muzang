require 'fileutils'
require 'yaml'

class PlusOne
  include Muzang::Plugin::Helpers

  attr_accessor :config, :stats

  def initialize(bot)
    @bot = bot
    create_database("stats.yml", Hash.new, :stats)
  end

  def call(connection, message)
    if on_channel?(message)
      if (plus_for = match?(message, :regexp => /^([^\s]*) \+1/, :position => 1))
        plus_for.gsub!(":","")
        if filter(plus_for, message.nick)
          connection.msg(message.channel, "#{message.nick} pisze w PHP") and return
        end

        connection.msg(message.channel, "#{message.nick} podarowal +1 dla *#{plus_for}*")
        @stats[plus_for] ||= 0
        @stats[plus_for]  += 1
        save
      end

      if match?(message, :regexp => /^!stats$/, :position => 0)
        connection.msg(message.channel, print)
      end
    end
  end

  def print
    message = ""
    stat = @stats.sort_by { |points| -points[1] }
    stat.each do |s|
      message << "*#{s[0]}* #{s[1]} | " if s[1] > 0
    end

    message
  end

  def filter(plus_for, nick)
    if plus_for == nick || @stats[nick] == nil
      return true
    end
  end
end
