class ConnectionMock
  attr_accessor :message_count, :messages, :options, :nick

  def initialize(options = {})
    @message_count = 0
    options.each do |k, v|
      send(:"#{k}=", v)
    end
  end

  def msg(where, message)
    @message_count += 1
    (@messages ||= []) << message
  end
end
