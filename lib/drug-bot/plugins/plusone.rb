require 'fileutils'
require 'yaml'

class PlusOne
  attr_accessor :config, :stats

  def initialize(bot)
    unless File.exist?(@config = ENV["HOME"] + "/.drug-bot")
      FileUtils.mkdir @config
    end

    unless File.exist? @config + "/stats.yml"
      db = YAML::dump Hash.new
      File.open(@config + "/stats.yml", "w"){|f| f.write(db)}
    end

    @stats = YAML::load File.open(@config + "/stats.yml", "r").read
  end

  def call(connection, message)
    if message[:channel]
      if (plus_for = message[:message].match(/^([^\s]*) \+1/).to_a[1])
        plus_for.gsub!(":","")
        if filter(plus_for, message[:nick])
          connection.msg(message[:channel], "#{message[:nick]} pisze w PHP") and return
        end

        connection.msg(message[:channel], "#{message[:nick]} podarowal +1 dla *#{plus_for}*")
        @stats[plus_for] ||= 0
        @stats[plus_for]  += 1
        save
      end

      if message[:message].match(/^!stats$/) && message[:message].match(/^!stats$/)[0]
        connection.msg(message[:channel], print)
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

  def save
    file = File.open(@config + "/stats.yml", "w"){|f| f.write YAML::dump(@stats)}
  end

  def filter(plus_for, nick)
    if plus_for == nick || @stats[nick] == nil
      return true
    end
  end
end
