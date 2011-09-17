Cramp::Websocket.backend = :thin

class Termvana::WebsocketAction < Cramp::Websocket
  self.transport = :websocket

  on_data :received_data
  on_start :opened_conn
  on_finish :closed_conn

  attr_accessor :environment

  def opened_conn
    @environment = Termvana::Environment.new(:env => {"HOME" => ENV['HOME']})
    @environment.messenger do |message|
      render message.to_s
    end
    render Termvana::Response.new(:message => "Welcome to Nirvana. Websocket connected.", :type => :on_connect).to_s
    # resulvt = Termvana::Runner.run ARGV
    # send(result) unless result.to_s.empty?
  end

  def received_data(data)
    command = Termvana::Request.new(data)
    callable = Termvana::CommandProcessor.parse(environment, command)
    callable.call
  end

  def closed_conn
    # Ripl.shell.after_loop
    STDERR.puts "Browser disconnecting."
  end

end

