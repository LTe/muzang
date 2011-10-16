class ConnectionMock
  attr_accessor :message_count, :messages, :options

  def initialize(options = {})
    options.each do |k, v|
      send(:"#{k}=", v)
    end
  end

  def msg(where, message)
    @message_count ||= 0
    @messages ||= []

    @message_count += 1
    @messages << message
  end

  def message_count
    @message_count || 0
  end
end
