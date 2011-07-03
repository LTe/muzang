require 'net/http'
require 'tempfile'

class PlusOneStats
  include Cinch::Plugin

  match "stats"
  match /^([\w\d_:]*) \+1/, :method => :plus_one, :use_prefix => false

  def plus_one(m, nick)
    m.reply("*#{m.user.nick}* podarowal +1 dla #{nick.gsub(":", "")}")
  end

  def execute(m)
    result = statistic(irc_log)
    m.reply(pretty_print(result))
  end

  protected

  def irc_log
    file = Tempfile.new('irc.log')

    Net::HTTP.start('irc.mlomnicki.com') do |http|
      req = Net::HTTP::Get.new('/')
      req.basic_auth 'drug', 'drug'
      response = http.request(req)
      file.write response.body
      file.rewind
    end

    file
  end

  def statistic(file)
    nicks = {}

    file.each_line do |line|
      /\d{2}:\d{2} < ([\w\d]*)>(.*)/.match(line) do |match_line|
        author = match_line[1]
        nicks[author] ||= 0
        text = match_line[2]

        if text.include?("+1")
          nicks.each do |nick, points|
            if text.include?(nick)
              nicks[nick] += 1 unless nick == author
            end
          end
        end
      end
    end

    nicks
  end

  def pretty_print(result)
    message = ""

    array = result.sort_by{|k,v|-v}

    array.each do |r|
      message << " *#{r[0]}* - #{r[1]} |" if r[1] > 0
    end

    message
  end

end
