Cramp::Websocket.backend = :thin

class WebsocketAction < Cramp::Websocket
  self.transport = :websocket

  on_data :received_data
  on_start :opened_conn
  on_finish :closed_conn

  def opened_conn
    render "Connected to websocket"
    # resulvt = Termvana::Runner.run ARGV
    # send(result) unless result.to_s.empty?
  end

  def received_data(data)
    process =  EM::DeferrableChildProcess.open(data)
    process.callback do |data|
      render data
    end
    process.errback do |data|
      render "Command timed out."
    end
    process.timeout(10)
    # Ripl.shell.web_loop_once(data)
  end

  def closed_conn
    Ripl.shell.after_loop
  end

end

