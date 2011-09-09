require 'em-websocket'
require 'termvana'
require 'pidly'

module Termvana
  class Websocket < Pidly::Control
    start :on_start

    def on_start
      EventMachine.run do
        EventMachine::WebSocket.start(:host => '127.0.0.1', :port => 8080) do |ws|
          
        end
      end
    rescue
      message = "Unable to start websocket since port 8080 is occupied"
      message = $!.message unless $!.message[/no acceptor/]
      abort "termvana websocket error: #{message}"
    end
  end
end
