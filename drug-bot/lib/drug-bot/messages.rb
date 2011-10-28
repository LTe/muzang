module Coffeemaker
  class Bot
    class Irc
      class Message
        def [](other)
          self.send(other)
        end
      end
    end
  end
end
