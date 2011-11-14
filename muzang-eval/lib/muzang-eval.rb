module Safe; end
class << Safe
   def safe(code, sandbox=nil)
     error = nil

     begin
       $-w = nil
       sandbox ||= Object.new.taint
       yield(sandbox) if block_given?

       $SAFE = 5
       value = eval(code, sandbox.send(:binding))
       result = Marshal.load(Marshal.dump(value))
     rescue Exception => error
       error = Marshal.load(Marshal.dump(error))
     end

     return result, error
   end
end

def safe(*args, &block)
  unless args.first =~ /EM|EventMachine/
    Safe::safe(*args, &block)
  end
end

class Eval
  include Muzang::Plugin::Helpers

  def initialize(bot)
    @bot = bot
  end

  def call(connection, message)
    if on_channel?(message)
      if match?(message, :regexp => /^\% (.*)/, :position => 1)
        operation = proc do
          safe(message.message.match(/^\% (.*)/)[1])
        end
        callback = proc do |tuple|
          result, error = tuple
          connection.msg(message.channel, "#{result}") if result
          connection.msg(message.channel, "Error: #{error}") if error
        end
        EM.defer(operation, callback)
      end
    end
  end
end

