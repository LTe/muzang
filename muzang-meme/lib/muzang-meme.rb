require "em-http-request"
require "json"

class Meme
  include Muzang::Plugin::Helpers

  MEMES = {
    "idont" =>  { :image_id => 2485, :generator => 74 },
    "yuno"  =>  { :image_id => 166088, :generator => 2 },
    "orly"  =>  { :image_id => 117049, :generator => 920 },
    "suc"   =>  { :image_id => 1031, :generator => 121 },
    "all"   =>  { :image_id => 1121885, :generator => 6013 }
  }

  def initialize(bot)
    @bot = bot
  end

  def call(connection, message)
    message.message.match(/^meme$/) do
      connection.msg("#{@bot.channel}", "Type 'meme [name of meme] \"Text0\" \"Text1\"'")
      connection.msg("#{@bot.channel}", "Available memes: #{MEMES.keys.join(" ")}")
    end
    message.message.match(/^meme (.*?) "(.*?)"( "(.*?)")?$/) do |m|
      if meme_ids = MEMES[m[1]]
        @generator = meme_ids[:generator]
        @image_id  = meme_ids[:image_id]
      else
        return nil
      end

      @text0 = m[2]
      @text1 = m[4]

      http = EventMachine::HttpRequest.new('http://version1.api.memegenerator.net/Instance_Create')
             .get(:query => {:username => 'drug-bot',
                             :password => 'drug-bot',
                             :languageCode => 'en',
                             :generatorID => @generator,
                             :imageID => @image_id,
                             :text0 => @text0,
                             :text1 => @text1})

      http.callback {
        meme = JSON.parse(http.response)
        url = "http://version1.api.memegenerator.net#{meme['result']['instanceImageUrl']}"
        connection.msg("#{@bot.channel}", "Meme: #{url}")
      }
    end
  end
end
