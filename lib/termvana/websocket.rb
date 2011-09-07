require 'em-websocket'
require 'termvana'
require 'pidly'

module Termvana
  class Websocket < Pidly::Control
    start :on_start

    def on_start
      EventMachine.run do
        EventMachine::WebSocket.start(:host => '127.0.0.1', :port => 8080) do |ws|
          ws.onopen {
            result = Termvana::Runner.run ARGV
            ws.send(result) unless result.to_s.empty?
          }
          ws.onmessage {|msg| ws.send Ripl.shell.web_loop_once(msg) }
          ws.onclose { Ripl.shell.after_loop }
        end
      end
    rescue
      message = "Unable to start websocket since port 8080 is occupied"
      message = $!.message unless $!.message[/no acceptor/]
      abort "termvana websocket error: #{message}"
    end
  end
end
