require "rover_simulator"

class RoverServer

  LOCALHOST = "127.0.0.1".freeze

  def initialize(port:, rover: RoverSimulator.new)
    @port = port
    @rover = rover
    @client_socket = nil
    @thread = nil
  end

  def start
    return if @thread

    @thread = Thread.new do
      tcp_server = TCPServer.new(LOCALHOST, @port)
      while @client_socket = tcp_server.accept
        # First message
        @client_socket.print @rover.greeting

        # Command / answer loop
        while (command_line = @client_socket.gets)
          @rover.receive(command_line)
          @client_socket.print @rover.answer
        end
      end
    end
  end

  def stop
    return if @thread.nil?

    if @client_socket
      @client_socket.close
    end

    if @thread.alive?
      @thread.terminate
      @thread.join
    end

    @client_socket = nil
    @thread = nil
  end

end
