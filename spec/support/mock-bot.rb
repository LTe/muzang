# https://github.com/vangberg/isaac/blob/master/test/helper.rb

class MockSocket
  def self.pipe
    socket1, socket2 = new, new
    socket1.in, socket2.out = IO.pipe
    socket2.in, socket1.out = IO.pipe
    [socket1, socket2]
  end

  attr_accessor :in, :out
  def gets()
    Timeout.timeout(1) {@in.gets}
  end
  def read_nonblock(number)
    gets()
  end
  def write(m) @out.write(m) end
  def puts(m) @out.puts(m) end
  def print(m) @out.print(m) end
  def eof?() @in.eof? end
  def empty?
    begin
      @in.read_nonblock(1)
      false
    rescue Errno::EAGAIN
      true
    end
  end
end

module MockBot
  def mock_bot(&block)
    @socket, @server = MockSocket.pipe
    TCPSocket.stub(:new).and_return(@socket)
    bot = Cinch::Bot.new(&block)
  end

  def bot_is_connected
    @server.gets.should == "NICK #{@bot.config.nick}\r\n"
    @server.gets.should == "\r\n"
    @server.gets.should == "USER cinch 0 * :cinch\r\n"

    1.upto(4) {|i| @server.print ":localhost 00#{i} #{@bot.config.nick}\r\n"}

    @server.gets.should == "\r\n"
    @server.gets.should == "JOIN #{@bot.config.channels[0]}\r\n"
  end

  def join_to_channel(channel)
    @server.print ":#{@bot.config.nick} MODE #{@bot.config.nick} :+i\r\n"
    @server.print ":#{@bot.config.nick}!~localhost JOIN :##{channel}\r\n"
    @server.gets.should == "\r\n"
    @server.gets.should == "NAMES #{@bot.config.channels[0]}\r\n"
    @server.gets.should == "\r\n"
    @server.gets.should == "MODE #{@bot.config.channels[0]} +b\r\n"
    @server.gets.should == "\r\n"
    @server.gets.should == "MODE #{@bot.config.channels[0]}\r\n"
  end
end
