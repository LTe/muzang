class ConnectionMock
  attr_accessor :message_count, :options

  def initialize(options = {})
    options.each do |k, v|
      send(:"#{k}=", v)
    end
  end

  def msg(where, message)
    @message_count ||= 0
    @message_count += 1
  end

  def message_count
    @message_count || 0
  end
end
