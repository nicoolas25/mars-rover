require "socket"
require "timeout"

require "rover_server"

RSpec.describe RoverServer do
  let(:instance) { described_class.new(port: port, rover: rover) }
  let(:port) { (3000..3100).to_a.sample }
  let(:rover) { RoverSimulator.new }

  describe "#start" do
    subject(:start) do
      instance.start.tap do
        # Leave a small amount of time to let the tcp server start
        sleep 0.001
      end
    end

    after { instance.stop }

    it "listens for a connection on the given port" do
      start
      expect_a_listening_tcp_server
    end

    it "sends a position and a direction as its greeting" do
      start
      expect_a_listening_tcp_server do |client_socket|
        greeting = client_socket.gets
        expect(greeting).to eq rover.greeting
      end
    end

    it "receives sequences of commands and reply with rover's answer" do
      command = "ffrbblffrbbl\n"
      start
      expect_a_listening_tcp_server do |client_socket|
        client_socket.gets          # read the greeting
        2.times do
          client_socket.print command # send the command
          reply = client_socket.gets  # read the answer from the rover
          expect(reply).to eq rover.answer
        end
      end
    end

    it "listens even when the client closed the connection" do
      start

      2.times do
        expect_a_listening_tcp_server do |client_socket|
          client_socket.gets
          client_socket.close
        end
      end
    end
  end

  def expect_a_listening_tcp_server(&block)
    expect do
      Timeout.timeout(2) do
        TCPSocket.open(described_class::LOCALHOST, port) do |client_socket|
          expect(client_socket.addr).to be_an Array
          yield client_socket if block
        end
      end
    end.not_to raise_error
  end
end
