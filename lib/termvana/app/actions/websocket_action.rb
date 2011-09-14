Cramp::Websocket.backend = :thin

class WebsocketAction < Cramp::Websocket
  self.transport = :websocket

  on_data :received_data
  on_start :opened_conn
  on_finish :closed_conn

  attr_accessor :environment

  def opened_conn
    @environment = Environment.new
    @environment.messenger do |message|
      render message.to_s
    end
    render Response.new(:message => "Welcome to Nirvana. Websocket connected.", :type => :on_connect).to_s
    # resulvt = Termvana::Runner.run ARGV
    # send(result) unless result.to_s.empty?
  end

  def received_data(data)
    command = Command.new(data)
    if command.full_command =~ /^cd (.+)/
      environment.cwd = $1 
      response = Response.new(:message => "")
      render response.to_s
    else
      # Change this - leaves open shells lying around.
      process =  EM.popen("bash", CommandProcessor, environment, command) do |c|
        c.prepare_and_run
      end
      # Allow timeout - mixin EventMachine::Deferrable
      process.callback do |data|
        response = Response.new(:message => data)
        render response.to_s
      end
      process.errback do |data|
        render Response.new(:message => "Command timed out.", :type => :error).to_s
      end
      process.timeout(10)
    end
    # Ripl.shell.web_loop_once(data)
      #
  end

  def closed_conn
    # Ripl.shell.after_loop
    STDERR.puts "Browser disconnecting."
  end

end

