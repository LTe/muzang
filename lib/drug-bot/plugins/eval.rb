module Safe; end
class << Safe
   def safe(code, sandbox=nil)
     error = nil

     begin
       thread = Thread.new {
         $-w = nil

         sandbox ||= Object.new.taint

         yield(sandbox) if block_given?

         $SAFE = 5
         eval(code, sandbox.send(:binding))
       }
       value = thread.value
       result = Marshal.load(Marshal.dump(thread.value))
     rescue Exception => error
       error = Marshal.load(Marshal.dump(error))
     end

     return result, error
   end
end

def safe(*args, &block)
   Safe::safe(*args, &block)
end

class Eval
  def initialize(bot)
    @bot = bot
  end

  def call(connection, message)
    if message[:channel]
      if message[:message].match(/^\% (.*)/) && message[:message].match(/^\% (.*)/)[1]
        result, error = safe(message[:message].match(/^\% (.*)/)[1])
        connection.msg(message[:channel], "#{result}") if result
        connection.msg(message[:channel], "Error: #{error}") if error
      end
    end
  end
end

